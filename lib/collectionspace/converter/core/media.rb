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
          pairs = {
            'identificationnumber' => 'identificationNumber',
            'title' => 'title',
            'copyrightstatement' => 'copyrightStatement',
            'coverage' => 'coverage',
            'source' => 'source',
            'sourceurl' => 'externalUrl',
            'contributorperson' => 'contributor',
            'contributororganization' => 'contributor',
            'creatorperson' => 'creator',
            'creatororganization' => 'creator',
            'description' => 'description',
            'publisherperson' => 'publisher',
            'publisherorganization' => 'publisher',
            'rightsholderperson' => 'rightsHolder',
            'rightsholderorganization' => 'rightsHolder',

          }
          pairstransforms = {
            'contributorperson' => {'authority' => ['personauthorities', 'person']},
            'contributororganization' => {'authority' => ['orgauthorities', 'organization']},
            'creatorperson' => {'authority' => ['personauthorities', 'person']},
            'creatororganization' => {'authority' => ['orgauthorities', 'organization']},
            'publisherperson' => {'authority' => ['personauthorities', 'person']},
            'publisherorganization' => {'authority' => ['orgauthorities', 'organization']},
            'rightsholderperson' => {'authority' => ['personauthorities', 'person']},
            'rightsholderorganization' => {'authority' => ['orgauthorities', 'organization']},
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          repeats = { 
            'type' => ['typeList', 'type'],
            'language' => ['languageList', 'language'],
            'subject' => ['subjectList', 'subject'],
            'relation' => ['relationList', 'relation'],
          }
          repeatstransforms = {
            'language' => {'vocab' => 'languages'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          #dateGroupList, dateGroup
          CSXML::Helpers.add_date_group_list(
            xml, 'date', attributes["date"]
          )
          #measuredPartGroupList, measuredPartGroup, dimensionSubGroupList, dimensionSubGroup
          CSXML::Helpers.add_measured_part_group_list(xml, attributes)
        end
      end
    end
  end
end
