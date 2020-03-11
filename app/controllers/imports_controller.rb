class ImportsController < ApplicationController

  def new; end

  def create
    file = params[:file]
    unless file.respond_to? :path
      flash[:error] = "There was an error processing the uploaded file."
      redirect_to action: 'new' && return
    end

    config = {
      key: SecureRandom.uuid,
      filename: file.path,
      batch: params[:batch],
      module: params[:module],
      profile: params[:profile]
    }

    begin
      Batch.create!(
        key: config[:key],
        category: 'import',
        type: 'import',
        for: config[:profile],
        name: config[:batch],
        start: Time.now,
        total: Lookup.csv_row_count(file.path)
      )

      ::SmarterCSV.process(File.open(file.path, 'r:bom|utf-8'), {
        auto_row_sep_chars: 10_000,
        chunk_size: 100,
        convert_values_to_numeric: false,
        required_headers: Lookup.profile_headers(params[:profile]),
        # TODO: evaluate performance with large csv
        row_sep: :auto
      }.merge(Rails.application.config.csv_parser_options)) do |chunk|
        if Lookup.async?
          ImportJob.perform_later(config, chunk)
        else
          ImportJob.perform_now(config, chunk)
        end
      end
      flash[:notice] = "Background import job running. Check back periodically for results."
    rescue StandardError => err
      batch = Batch.retrieve(config[:key])
      batch&.destroy
      flash[:error] = "Import error: #{err.message}"
    end
    redirect_to batches_path
  end
end
