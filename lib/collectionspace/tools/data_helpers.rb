module CollectionSpace
  module Tools
    class DataHelpers
      ::CSDH = CollectionSpace::Tools::DataHelpers
      
      def self.split_value(value)
        value = value.to_s unless value.is_a?(String)
        value = value.split(Rails.application.config.csv_mvf_delimiter)
        value = value.map(&:strip)
        return value
      end
    end
  end
end
