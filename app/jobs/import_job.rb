class ImportJob < ActiveJob::Base
  queue_as :default

  def perform(config, rows = [])
    profile = Lookup.profile(config[:profile])
    attributes = {
      converter_profile: config[:profile],
      csv_data: {},
      identify_by_column: profile['identify_by_column'],
      import_batch: config[:batch],
      import_category: profile['type'],
      import_file: config[:filename],
    }

    rows.each do |data|
      # TODO: RowValidator.new(profile[:validate], data)
      attributes[:csv_data] = data
      if Lookup.async?
        RowJob.perform_later(attributes, config[:key])
      else
        RowJob.perform_now(attributes, config[:key])
      end
    end
  end
end
