class ImportJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    attributes = {
      converter_profile: config[:profile],
      csv_data: {},
      import_batch: config[:batch],
      import_category: Lookup.profile_type(config[:profile]),
      import_file: config[:filename],
    }

    rows.each do |data|
      attributes[:csv_data] = data
      if Lookup.async?
        RowJob.perform_later(attributes, config[:key])
      else
        RowJob.perform_now(attributes, config[:key])
      end
    end
  end
end
