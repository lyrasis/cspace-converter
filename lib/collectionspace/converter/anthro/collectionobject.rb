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

          commingled_remains_data = {
            'ageRange' => 'agerange',
            'behrensmeyerUpper' => 'behrensmeyerupper',
            'behrensmeyerSingleLower' => 'behrensmeyersinglelower',
            'commingledRemainsNote' =>  'commingledremainsnote',
            'sex' => 'sex',
            'count' => 'count',
            'minIndividuals' => 'minindividuals',
            'dentition' => 'dentition',
            'bone' => 'bone',
            'mortuaryTreatment' => 'mortuarytreatment',
            'mortuaryTreatmentNote' => 'mortuarytreatmentnote'
          }
          mortuary_treatment_fields = [
            'mortuaryTreatment',
            'mortuaryTreatmentNote'
          ]
          
          CSXML.add_nested_group_lists(
            xml, attributes,
            'commingledRemains',
            commingled_remains_data,
            'mortuaryTreatment',
            mortuary_treatment_fields,
            topGroupList: true,
            childGroupList: true,
            childListPrefix: false
            )
        end
      end
    end
  end
end
