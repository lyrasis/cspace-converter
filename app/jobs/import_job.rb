require 'json'

class ImportJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    type = Lookup.profile_type(config[:profile])

    batch = Batch.where(
      key: config[:key]
    ).first || Batch.new(
      key: config[:key],
      category: 'import',
      type: Lookup.converter_class,
      for: config[:profile],
      name: config[:batch],
      status: 'running',
      processed: 0,
      failed: 0,
      start: Time.now,
      end: nil
    )
    batch.status = 'running' # reset running status
    batch.save

    CacheService.refresh

    data_object_attributes = {
      converter_profile: config[:profile],
      csv_data: {},
      import_batch: config[:batch],
      import_category: type,
      import_file: config[:filename],
    }

    rows.each do |data|
      batch.processed += 1
      data_object_attributes[:csv_data] = data
      service = Lookup.import_service(type).new(
        config[:profile],
        data_object_attributes
      )
      begin
        logger.debug "Importing row: #{data_object_attributes.inspect}"
        service.create_object
        service.process
        if service.object.collection_space_objects.count.zero?
          raise 'No records were created.'
        end
        service.update_status(import_status: 1, import_message: 'ok')
      rescue Exception => ex
        logger.error "Error for import row: #{ex.message}"
        service.update_status(import_status: 0, import_message: ex.message)
        service.object.collection_space_objects.destroy_all
        batch.failed += 1
      end
    end
    batch.status = 'complete'
    batch.end = Time.now
    batch.save
  end
end
