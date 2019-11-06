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

        def self.pairs
          {
            'identificationnumber' => 'identificationNumber',
            'title' => 'title',
            'copyrightstatement' => 'copyrightStatement',
            'coverage' => 'coverage',
            'source' => 'source',
            'sourceurl' => 'externalUrl',
          }
        end

        def self.map(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreMedia.pairs)
          CSXML::Helpers.add_person xml, 'contributor', attributes["contributor"] if attributes["contributortype"] == "person"
          CSXML::Helpers.add_organization xml, 'contributor', attributes["contributor"] if attributes["contributortype"] == "organization"
          CSXML::Helpers.add_person xml, 'creator', attributes["creator"] if attributes["creatortype"] == "person"
          CSXML::Helpers.add_organization xml, 'creator', attributes["creator"] if attributes["creatortype"] == "organization"
          CSXML::Helpers.add_date_group_list(
            xml, 'date', [CSDTP.parse(attributes['date'])]
          )
          CSXML.add xml, 'description', scrub_fields([attributes["description"]])
          CSXML::Helpers.add_measured_part_group_list(xml, attributes)
          CSXML.add_repeat xml, 'language', [{'language' => CSXML::Helpers.get_vocab('languages', attributes["language"])}], 'List'
          CSXML::Helpers.add_person xml, 'publisher', attributes["publisher"] if attributes["publishertype"] == "person"
          CSXML::Helpers.add_organization xml, 'publisher', attributes["publisher"] if attributes["publishertype"] == "organization"
          CSXML.add_repeat xml, 'relation', [{'relation' => attributes['relation']}], 'List'
          CSXML::Helpers.add_person xml, 'rightsHolder', attributes["rightsholder"] if attributes["rightsholdertype"] == "person"
          CSXML::Helpers.add_organization xml, 'rightsHolder', attributes["rightsholder"] if attributes["rightsholdertype"] == "organization"
          CSXML.add_repeat xml, 'subject', [{'subject' => attributes['subject']}], 'List'
          CSXML.add_repeat xml, 'type', [{'type' => attributes['type']}], 'List'
        end
      end
    end
  end
end
