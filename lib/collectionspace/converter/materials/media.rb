require_relative '../core/media'
module CollectionSpace
  module Converter
    module Materials
      include Default
      class MaterialsMedia < CollectionSpace::Converter::Core::CoreMedia
        def convert
          super do |xml|
            CSXML.add xml, 'contributor', attributes["contributor"]
            CSXML.add xml, 'copyrightStatement', attributes["copy_right_statement"]
            CSXML.add xml, 'creator', attributes["creator"]
            CSXML.add xml, 'dateCreated', attributes["date_created"]
            CSXML.add xml, 'dateModified', attributes["date_modified"]
            CSXML.add xml, 'filename', attributes["filename"]
            # https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Builder
            CSXML.add xml, "format_", attributes["format"]
            CSXML.add xml, 'language', attributes["language"]
            CSXML.add xml, 'location', attributes["location"]
            CSXML.add xml, 'publisher', attributes["publisher"]
            CSXML.add xml, 'relation', attributes["relation"]
            CSXML.add xml, 'rightsHolder', attributes["rights_holder"]
            CSXML.add xml, 'source', attributes["source"]
            CSXML.add xml, 'sourceURL', attributes["source_url"]
            CSXML.add xml, 'subject', attributes["subject"]
            CSXML.add xml, 'type', attributes["type"]
            CSXML.add_group_list xml, "objectProductionDate", [{
              "dateAssociation" => attributes["date_association"],
              "dateEarliestSingleYear" => attributes["date_earliest_single_year"],
              "dateEarliestSingleMonth" => attributes["date_earliest_single_month"],
              "dateEarliestSingleDay" => attributes["date_earliest_single_day"],
              "dateEarliestSingleEra" => attributes["date_earliest_single_era"],
              "dateEarliestSingleCertainty" => attributes["date_earliest_single_certainty"],
              "dateEarliestSingleQualifier" => attributes["date_earliest_single_qualifier"],
              "dateEarliestSingleQualifierValue" => attributes["date_earliest_single_qualifier_value"],
              "DateEarliestSingleQualifierUnit" => attributes["date_earliest_single_qualifier_unit"],
              "dateLatestSingleYear" => attributes["date_latest_single_year"],
              "dateLatestSingleMonth" => attributes["date_latest_single_month"],
              "dateLatestSingleDay" => attributes["date_latest_single_day"],
              "dateLatestSingleEra" => attributes["date_latest_single_era"],
              "dateLatestSingleCertainty" => attributes["date_latest_single_certainty"],
              "dateLatestSingleQualifier" => attributes["date_latest_single_qualifier"],
              "dateLatestSingleQualifierValue" => attributes["date_latest_single_qualifier_value"],
              "DateLatestSingleQualifierUnit" => attributes["date_latest_single_qualifier_unit"],
              "datePeriod" => attributes["date_period"],
              "dateNote" => attributes["date_note"]

            }]
            overall_data = {
              "measuredPart" => attributes["dimension_part"],
              "dimensionSummary" => attributes["dimension_summary"],
              "measuredBy" => attributes["measured_by"],
              "measurementMethod" => attributes["measurement_method"],
              "valueDate" => attributes["value_date"],
              "value_qualifier" => attributes["value_qualifier"],
              "dimensionNote" => attributes["dimension_note"],
            }
            dimensions = []
            dims = split_mvf attributes, 'dimension'
            values = split_mvf attributes, 'value'
            unit = attributes["unit"]
            dims.each_with_index do |dim, index|
              dimensions << { "dimension" => dim, "value" => values[index], "measurementUnit" => unit }
            end
            CSXML.add_group_list xml, 'measuredPart', [ overall_data ], 'dimension', dimensions
          end
        end
      end
    end
  end
end
