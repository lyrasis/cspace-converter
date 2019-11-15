class RowJob < ActiveJob::Base
  queue_as :default

  def perform(attributes, key)
    import_status = 1
    begin
      service = Lookup.import_service(attributes[:import_category]).new(
        attributes[:converter_profile],
        attributes
      )
      logger.debug "Importing row: #{attributes.inspect}"
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
      batch.failed += 1 if import_status.zero?
      batch.end = Time.now
      batch.save
    end
  end
end
