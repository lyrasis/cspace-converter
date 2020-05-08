module CollectionSpace
  module Converter
    module Lhmc
      class LhmcCollectionObject < CollectionObject
        ::LhmcCollectionObject = CollectionSpace::Converter::Lhmc::LhmcCollectionObject
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:collectionobjects_common",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              LhmcCollectionObject.map_common(xml, attributes, redefined_fields)
            end

            xml.send(
              "ns2:collectionobjects_culturalcare",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/culturalcare",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              LhmcCollectionObject.map_cultural_care(xml, attributes, redefined_fields)
            end

            xml.send(
                "ns2:collectionobjects_lhmc",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/lhmc",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              LhmcCollectionObject.map_lhmc(xml, attributes)
            end

          end
        end

        def redefined_fields
          @redefined.concat([
            'contentplace',
            'inscriptioncontenttype',
            'inscriptioncontentmethod',
            'objectproductionplace',
            'assocplace',
            'ownershipplace'
          ])
          super
        end

        # CORE
        def self.map_common(xml, attributes, redefined)
          CoreCollectionObject.map_common(xml, attributes.merge(redefined))

          #otherNumberList, otherNumber
          othernumber_data = {
            'numbervalue' => 'numberValue',
            'numbertype' => 'numberType'
          }
          othernumber_transforms = {
            'numbertype' => {'vocab' => 'numbertype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'otherNumber',
            othernumber_data,
            othernumber_transforms,
            list_suffix: 'List',
            group_suffix: ''
          )
        end

        # PROFILE
        def self.map_lhmc(xml, attributes)
          # no fields are added except for those from cultural care extension
        end

        # EXTENSIONS
        def self.map_cultural_care(xml, attributes, redefined)
          CulturalCareCollectionObject.map_cultural_care(xml, attributes.merge(redefined))
        end

        
        def self.map_anthro(xml, attributes)
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

          CSXML.add_single_level_group_list(
            xml, attributes,
            'locality',
            locality_data,
            locality_transforms
          )

          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          # commingledRemainsGroupList
          # -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=
          commingled_remains_data = {
            'agerange' => 'ageRange',
            'behrensmeyerupper' => 'behrensmeyerUpper',
            'behrensmeyersinglelower' => 'behrensmeyerSingleLower',
            'commingledremainsnote' => 'commingledRemainsNote',
            'commingledremainssex' => 'sex',
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
            sublist_suffix: 'GroupList',
            subgroup_suffix: 'Group',
          )
        end

        def self.map_annotation(xml, attributes)
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
            'annotationdate' => {'special' => 'unstructured_date_string'}
          }

          CSXML.add_single_level_group_list(
            xml, attributes,
            'annotation',
            annotation_data,
            annotation_transforms
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

          repeats = {
            'repatriationnote' => ['repatriationNotes', 'repatriationNote'],
            'nagpracategory' => ['nagpraCategories', 'nagpraCategory']
          }
          repeat_transforms = {
            'nagpracategory' => { 'vocab' => 'nagpracategory' }
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)

          CSXML::Helpers.add_date_group(
            xml, 'nagpraReportFiledDate', CSDTP.parse(attributes['nagprareportfileddate']), ''
            )

        end
      end
    end
  end
end
