module CollectionSpace
  module Converter
    module Anthro
      class AnthroCollectionObject < CollectionObject
        ::AnthroCollectionObject = CollectionSpace::Converter::Anthro::AnthroCollectionObject
        def convert
          run do |xml|
            AnthroCollectionObject.map(xml, attributes)
          end
        end

        def self.pairs
          {
            'fieldloccounty' => 'fieldLocCounty',
            'fieldlocstate' => 'fieldLocState',
            'localitynote' => 'localityNote'
          }
        end

        def self.map(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, AnthroCollectionObject.pairs)

          crgsplit = {
            'ageRange' => split_mvf(attributes, 'agerange'),
            'behrensmeyerUpper' => split_mvf(attributes, 'behrensmeyerupper'),
            'behrensmeyerSingleLower' => split_mvf(attributes, 'behrensmeyersinglelower'),
            'commingledRemainsNote' =>  split_mvf(attributes, 'commingledremainsnote'),
            'sex' => split_mvf(attributes, 'sex'),
            'count' => split_mvf(attributes, 'count'),
            'minIndividuals' => split_mvf(attributes, 'minindividuals'),
            'dentition' => split_mvf(attributes, 'dentition'),
            'bone' => split_mvf(attributes, 'bone'),
            'mortuaryTreatment' => split_mvf(attributes, 'mortuarytreatment'),
            'mortuaryTreatmentNote' => split_mvf(attributes, 'mortuarytreatmentnote')
          }
          Rails.logger.warn('Multivalued fields used in commingledRemainsGroup have uneven numbers of values') unless mvfs_even?(crgsplit)
          remains_groups = flatten_mvfs(crgsplit)

          mortuary_groups = []
          remains_groups.each{ |h|
            mtsplit = {
              'mortuaryTreatment' => h['mortuaryTreatment'].split('^^'),
              'mortuaryTreatmentNote' => h['mortuaryTreatmentNote'].split('^^')
            }
            h.delete('mortuaryTreatment')
            h.delete('mortuaryTreatmentNote')
            Rails.logger.warn('Multivalued fields used in mortuaryTreatmentGroup have uneven numbers of values') unless mvfs_even?(mtsplit)
            mortuary_groups << flatten_mvfs(mtsplit)
          }
          CSXML.add_group_list(xml, 'commingledRemains', remains_groups, 'mortuaryTreatment', mortuary_groups)


        end
      end
    end
  end
end
