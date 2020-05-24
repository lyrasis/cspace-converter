namespace :import do
  def process(job_class, config)
    begin
      Batch.create!(
        key: config[:key],
        category: 'import',
        type: 'import',
        for: config[:profile],
        name: config[:batch],
        start: Time.now,
        total: Lookup.csv_row_count(config[:filename])
      )

      SmarterCSV.process(File.open(config[:filename], 'r:bom|utf-8'), {
        auto_row_sep_chars: 10_000,
        chunk_size: 100,
        convert_values_to_numeric: false,
        required_headers: Lookup.profile_headers(config[:profile]),
        # TODO: evaluate performance with large csv
        row_sep: :auto
      }.merge(Rails.application.config.csv_parser_options)) do |chunk|
        job_class.perform_now(config, chunk)
      end
      Rails.logger.debug "Data import complete. Use 'import:errors' task to review any errors."
    rescue StandardError => err
      batch = Batch.retrieve(config[:key])
      batch&.destroy
      Rails.logger.error "Import error: #{err.message}"
    end
  end

  # rake import:errors
  task :errors => :environment do |t, args|
    DataObject.where(import_status: 0).each do |object|
      Rails.logger.info object.inspect
    end
  end

  # rake import:csv[data/core/SampleCatalogingData.csv,cataloging1,cataloging]
  task :csv, [:filename, :batch, :profile] => :environment do |t, args|
    config = {
      key:       SecureRandom.uuid,
      filename:  args[:filename],
      batch:     args[:batch],
      profile:   args[:profile],
    }
    unless File.file? config[:filename]
      Rails.logger.error "#{config[:filename]} does not exist or is not a file"
      abort
    end
    Rails.logger.debug "Batch #{config[:batch]}; Profile #{config[:profile]}"
    process ImportJob, config
  end
end
