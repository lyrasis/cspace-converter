module CollectionSpace
  module Converter
    module CulturalCare
      class CulturalCareCollectionObject < CollectionObject
        ::CulturalCareCollectionObject = CollectionSpace::Converter::CulturalCare::CulturalCareCollectionObject
        def convert
          run do |xml|
            CulturalCareCollectionObject.map_common(xml, attributes)
          end
        end

        def self.map_cultural_care(xml, attributes)
          repeats = {
            'culturalcarenote' => ['culturalCareNotes', 'culturalCareNote']
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats)

          #accessLimitationsGroupList, accessLimitationsGroup
          aldata = {
            'limitationdetails' => 'limitationDetails',
            'limitationlevel' => 'limitationLevel',
            'limitationtype' => 'limitationType',
            'requestdate' => 'requestDate',
            'requester' => 'requester',
            'requestonbehalfof' => 'requestOnBehalfOf'
          }
          altransforms = {
            'limitationlevel' => {'vocab' => 'limitationlevel'},
            'limitationtype' => {'vocab' => 'limitationtype'},
            'requester' => {'authority' => ['personauthorities', 'person']},
            'requestonbehalfof' => {'authority' => ['orgauthorities', 'organization']},
            'requestdate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'accessLimitations',
            aldata,
            altransforms
          )
        end
        
      end
    end
  end
end
