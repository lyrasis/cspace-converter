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

            xml.send(
              "ns2:collectionobjects_annotation",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/annotation",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              AnthroCollectionObject.map_annotations(xml, attributes)
            end

            xml.send(
              "ns2:collectionobjects_nagpra",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/nagpra",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              AnthroCollectionObject.map_nagpra(xml, attributes)
            end
          end
        end

        def self.map(xml, attributes)
          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          # localityGroupList
          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          locality_data = {
            'fieldlocplace' => 'fieldLocPlace',
            'fieldloccounty' => 'fieldLocCounty',
            'fieldlocstate' => 'fieldLocState',
            'localitynote' => 'localityNote'
          }

          locality_transforms = {
            'fieldlocplace' => { 'authority' => ['placeauthorities', 'place'] }
          }

          CSXML.prep_and_add_single_level_group_list(
            xml, attributes,
            'locality',
            locality_data,
            locality_transforms,
            topGroupList: true
          )

          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          # commingledRemainsGroupList
          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          commingled_remains_data = {
            'agerange' => 'ageRange',
            'behrensmeyerupper' => 'behrensmeyerUpper',
            'behrensmeyersinglelower' => 'behrensmeyerSingleLower',
             'commingledremainsnote' => 'commingledRemainsNote',
            'sex' => 'sex',
            'count' => 'count',
            'minindividuals' => 'minIndividuals',
            'dentition' => 'dentition',
            'bone' => 'bone',
            'mortuarytreatment' => 'mortuaryTreatment',
            'mortuarytreatmentnote' => 'mortuaryTreatmentNote'
          }
          mortuary_treatment_fields = [
            'mortuaryTreatment',
            'mortuaryTreatmentNote'
          ]

          commingled_transforms = {
            'agerange' => {'replace' => [{'find' => ' - ',
                                          'replace' => '-',
                                          'type' => 'plain'}],
                           'vocab' => 'agerange'
                          },
            'behrensmeyerupper' => {'special' => 'behrensmeyer_translate',
                                    'vocab' => 'behrensmeyer'
                                   },
            'behrensmeyersinglelower' => {'special' => 'behrensmeyer_translate',
                                          'vocab' => 'behrensmeyer'
                                         },
            'dentition' => {'special' => 'boolean'},
            'mortuarytreatment' => {'vocab' => 'mortuarytreatment'}
          }

          CSXML.add_nested_group_lists(
            xml, attributes,
            'commingledRemains',
            commingled_remains_data,
            'mortuaryTreatment',
            mortuary_treatment_fields,
            commingled_transforms,
            topGroupList: true,
            childGroupList: true,
            childListPrefix: false
          )
        end

        def self.map_annotations(xml, attributes)
          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          # annotationGroupList
          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          annotation_data = {
            'annotationnote' => 'annotationNote',
            'annotationtype' => 'annotationType',
            'annotationdate' => 'annotationDate',
            'annotationauthor' => 'annotationAuthor'
          }

          annotation_transforms = {
            'annotationauthor' => {'authority' => ['personauthorities', 'person']},
            'annotationtype' => {'vocab' => 'annotationtype'},
            'annotationdate' => {'special' => 'unstructured_date'}
          }

          CSXML.prep_and_add_single_level_group_list(
            xml, attributes,
            'annotation',
            annotation_data,
            annotation_transforms,
            topGroupList: true
          )
        end
        
        def self.map_nagpra(xml, attributes)
          pairs = {
            'nagprareportfiled' => 'nagpraReportFiled',
            'nagprareportfiledby' => 'nagpraReportFiledBy'
          }
          pair_transforms = {
            'nagprareportfiled' => {'special' => 'boolean'},
            'nagprareportfiledby' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pair_transforms)

        end
      end
    end
  end
end
