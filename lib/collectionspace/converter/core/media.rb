module CollectionSpace
  module Converter
    module Core
      class CoreMedia < Media
        ::CoreMedia = CollectionSpace::Converter::Core::CoreMedia
        def convert
          run do |xml|
            CoreMedia.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'identificationNumber', attributes["identificationnumber"]
          CSXML.add xml, 'title', attributes["title"]
          CSXML::Helpers.add_person xml, 'contributor', attributes["contributor"]
          CSXML.add xml, 'copyrightStatement', attributes["copyrightstatement"]
          CSXML.add xml, 'coverage', attributes["coverage"]
          # measuredPartGroupList
          overall_data = {
            "measuredPart" => attributes["measuredpart"],
            "dimensionSummary" => attributes["dimensionsummary"],
          }
          dimensions = []
          dims = split_mvf attributes, 'dimension'
          values = split_mvf attributes, 'value'
          unit = attributes["measurementunit"]
          by = attributes["measuredby"] 
          method = attributes["measurementmethod"]
          date = attributes["valuedate"]
          qualifier = attributes["valuequalifier"]
          note = attributes["dimensionnote"]
          dims.each_with_index do |dim, index|
            dimensions << { "dimension" => dim, "value" => values[index], "measurementUnit" => unit, "measuredBy" => by, "measurementMethod" => method, "valueDate" => date, "valueQualifier" => qualifier, "dimensionNote" => note}
          end
          CSXML.add_group_list xml, 'measuredPart', [overall_data], 'dimension', dimensions
          CSXML.add xml, 'description', scrub_fields([attributes["description"]])
          CSXML.add xml, 'externalUrl', attributes["externalurl"]
        end
      end
    end
  end
end
