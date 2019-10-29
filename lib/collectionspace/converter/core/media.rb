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
          CSXML::Helpers.add_person xml, 'contributor', attributes["contributor"] if attributes["contributortype"] == "person"
          CSXML::Helpers.add_organization xml, 'contributor', attributes["contributor"] if attributes["contributortype"] == "organization"
          CSXML.add xml, 'copyrightStatement', attributes["copyrightstatement"]
          CSXML.add xml, 'coverage', attributes["coverage"]
          CSXML::Helpers.add_person xml, 'creator', attributes["creator"] if attributes["creatortype"] == "person"
          CSXML::Helpers.add_organization xml, 'creator', attributes["creator"] if attributes["creatortype"] == "organization"
          CSXML.add xml, 'description', scrub_fields([attributes["description"]])
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
          CSXML.add_list xml, 'language', [{'language' => attributes['language']}]
          CSXML::Helpers.add_person xml, 'publisher', attributes["publisher"] if attributes["publishertype"] == "person"
          CSXML::Helpers.add_organization xml, 'publisher', attributes["publisher"] if attributes["publishertype"] == "organization"
          CSXML.add_list xml, 'relation', [{'relation' => attributes['relation']}] 
          CSXML::Helpers.add_person xml, 'rightsHolder', attributes["rightsholder"] if attributes["rightsholdertype"] == "person"
          CSXML::Helpers.add_organization xml, 'rightsHolder', attributes["rightsholder"] if attributes["rightsholdertype"] == "organization"
          CSXML.add xml, 'source', attributes["source"]
          CSXML.add xml, 'externalUrl', attributes["sourceurl"]
          CSXML.add_list xml, 'subject', [{'subject' => attributes['subject']}]
          CSXML.add_list xml, 'type', [{'type' => attributes['type']}]   
        end
      end
    end
  end
end
