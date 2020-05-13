class RowJob < ActiveJob::Base
  queue_as :default

  def perform(attributes, key)
    import_status = 1
    begin
      service = Lookup.import_service(attributes[:import_category]).new(attributes)
      service.create_object
      service.process
      if service.object.collection_space_objects.count.zero?
        raise 'No records were created.'
      end
      service.update_status(import_status: import_status, import_message: 'ok')
    rescue Exception => ex
      import_status = 0
      logger.error "Error for import row: #{ex.message}"
      service.update_status(import_status: import_status, import_message: ex.message)
      service.object.collection_space_objects.destroy_all
    end
    batch = Batch.retrieve(key)
    batch.with_lock do
      batch.processed += 1
      import_status.zero? ? batch.failed += 1 : batch.succeeded += 1
      batch.end = Time.now
      batch.save
    end
  end
end
