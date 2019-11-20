class ImportsController < ApplicationController

  def new
    # form
  end

  def create
    file = params[:file]

    if file.respond_to? :path
      config = {
        key: SecureRandom.uuid,
        filename: file.path,
        batch: params[:batch],
        module: params[:module],
        profile: params[:profile],
      }

      Batch.create(
        key: config[:key],
        category: 'import',
        type: 'import',
        for: config[:profile],
        name: config[:batch],
        start: Time.now,
        total: CSV.read(file.path, headers: true).length
      )

      begin
        ::SmarterCSV.process(file.path, {
            chunk_size: 100,
            convert_values_to_numeric: false,
            required_headers: Lookup.profile_headers(params[:profile])
        }.merge(Rails.application.config.csv_parser_options)) do |chunk|
          if Lookup.async?
            ImportJob.perform_later(config, chunk)
          else
            ImportJob.perform_now(config, chunk)
          end
        end
        flash[:notice] = "Background import job running. Check back periodically for results."
      rescue StandardError => err
        Batch.retrieve(config[:key]).destroy
        flash[:error] = "Upload error: #{err.message}"
      end
      redirect_to batches_path
    else
      flash[:error] = "There was an error processing the uploaded file."
      redirect_to import_path
    end
  end
end
