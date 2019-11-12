namespace :import do
  def process(job_class, config)
    Batch.create(
      key: config[:key],
      category: 'import',
      type: Lookup.converter_class,
      for: config[:profile],
      name: config[:batch],
      start: Time.now
    )

    SmarterCSV.process(config[:filename], {
        chunk_size: 100,
        convert_values_to_numeric: false,
      }.merge(Rails.application.config.csv_parser_options)) do |chunk|
      job_class.perform_later(config, chunk)
      Delayed::Worker.new.run(Delayed::Job.last)
    end
    Rails.logger.debug "Data import complete. Use 'import:errors' task to review any errors."
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
      Rails.logger.error "Invalid file #{config[:filename]}"
      abort
    end
    Rails.logger.debug "Batch #{config[:batch]}; Profile #{config[:profile]}"
    process ImportJob, config
  end
end
