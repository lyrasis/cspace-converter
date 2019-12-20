module CollectionSpace
  module Converter
    module Anthro
      class AnthroCollectionObject < CollectionObject
        ::AnthroCollectionObject = CollectionSpace::Converter::Anthro::AnthroCollectionObject
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:collectionobjects_common",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              CoreCollectionObject.map(xml, attributes.merge(redefined_fields))
            end

            xml.send(
                "ns2:collectionobjects_anthro",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/anthro",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              AnthroCollectionObject.map(xml, attributes)
            end
          end
        end

        def self.map(xml, attributes)
          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          # localityGroupList
          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          locality_data = {
            'fieldLocPlace' => 'fieldlocplace',
            'fieldLocCounty' => 'fieldloccounty',
            'fieldLocState' => 'fieldlocstate',
            'localityNote' => 'localitynote'
          }

          vocab_config = {
            'fieldLocPlace' => { 'authority' => ['placeauthorities', 'place'] }
          }

          CSXML.prep_and_add_single_level_group_list(
            xml, attributes,
            'locality',
            locality_data,
            vocab_config,
            topGroupList: true
          )

          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          # commingledRemainsGroupList
          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
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

          processing_config = {
            'ageRange' => { 'replace' => [{ 'find' => ' - ',
                                          'replace' => '-',
                                          'type' => 'plain' }],
                            'vocab' => 'agerange'
                          },
            'behrensmeyerUpper' => { 'special' => 'behrensmeyer_translate',
                                    'vocab' => 'behrensmeyer'
                                   },
            'behrensmeyerSingleLower' => { 'special' => 'behrensmeyer_translate',
                                          'vocab' => 'behrensmeyer'
                                         },
            'dentition' => { 'special' => 'boolean' }
          }

          CSXML.add_nested_group_lists(
            xml, attributes,
            'commingledRemains',
            commingled_remains_data,
            'mortuaryTreatment',
            mortuary_treatment_fields,
            processing_config,
            topGroupList: true,
            childGroupList: true,
            childListPrefix: false
            )
        end
      end
    end
  end
end
