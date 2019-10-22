module Helpers
  def get_attributes(type, file)
    SmarterCSV.process(Rails.root.join('data', type, file), {
      chunk_size: 1,
      convert_values_to_numeric: false,
    }.merge(Rails.application.config.csv_parser_options)) do |chunk|
      return JSON.parse(chunk[0].to_json)
    end
  end
end
