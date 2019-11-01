require 'active_support/core_ext/date_time'

module CollectionSpace
  module Tools
    StructuredDate = Struct.new(
      :parsed_datetime,
      :date_string,
      :display_date,
      :earliest_day,
      :earliest_month,
      :earliest_year,
      :earliest_scalar,
      :latest_day,
      :latest_month,
      :latest_year,
      :latest_scalar
    )

    module DateParser
      ::CSDTP = CollectionSpace::Tools::DateParser

      def self.fields_for(date)
        {
          'scalarValuesComputed' => 'true',
          'dateDisplayDate' => date.display_date,
          'dateEarliestSingleYear' => date.earliest_year,
          'dateEarliestSingleMonth' => date.earliest_month,
          'dateEarliestSingleDay' => date.earliest_day,
          'dateEarliestScalarValue' => date.earliest_scalar,
          'dateEarliestSingleEra' => CSURN.get_vocab_urn('dateera', 'CE'),
          'dateLatestYear' => date.latest_year,
          'dateLatestMonth' => date.latest_month,
          'dateLatestDay' => date.latest_day,
          'dateLatestScalarValue' => date.latest_scalar,
          'dateLatestEra' => CSURN.get_vocab_urn('dateera', 'CE'),
        }
      end

      def self.parse(date_string, end_date_string = nil)
        begin
          date_string = date_string.strip
          date_string = "#{date_string}-01-01" if date_string =~ /^\d{4}$/

          parsed_earliest_date = DateTime.parse(date_string)
          parsed_latest_date = end_date_string ?
            DateTime.parse(end_date_string) : parsed_earliest_date + 1

          date = StructuredDate.new
          date.parsed_datetime = parsed_earliest_date
          date.date_string = date_string
          date.display_date = date_string

          date.earliest_day = parsed_earliest_date.day
          date.earliest_month = parsed_earliest_date.month
          date.earliest_year = parsed_earliest_date.year
          date.earliest_scalar = parsed_earliest_date.iso8601(3).sub('+00:00', "Z")

          date.latest_day = parsed_latest_date.day
          date.latest_month = parsed_latest_date.month
          date.latest_year = parsed_latest_date.year
          date.latest_scalar = parsed_latest_date.iso8601(3).sub('+00:00', "Z")
          date
        rescue StandardError
          StructuredDate.new
        end
      end
    end
  end
end
