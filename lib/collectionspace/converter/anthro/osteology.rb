module CollectionSpace
  module Converter
    module Anthro
      class AnthroOsteology < Osteology
        ::AnthroOsteology = CollectionSpace::Converter::Anthro::AnthroOsteology
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:osteology_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/osteology',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              AnthroOsteology.map(xml, attributes)
            end

            xml.send(
              'ns2:osteology_anthropology',
              'xmlns:ns2' => 'http://collectionspace.org/services/osteology/domain/anthropology',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              AnthroOsteology.extension(xml, attributes)
            end
          end
        end

        def self.extension(xml, attributes)
          pairs = {
            'notes_dentalpathology' => 'Notes_DentalPathology',
            'cranialdeformationnote' => 'cranialDeformationNote',
            'cranialdeformationpresent' => 'cranialDeformationPresent',
            'notes_nhtaphonomicalterations' => 'Notes_NHTaphonomicAlterations',
            'notes_culturalmodifications' => 'Notes_CulturalModifications',
            'notes_curatorialsuffixing' => 'Notes_CuratorialSuffixing',
            'notes_postcranialpathology' => 'Notes_PostcranialPathology',
            'notes_cranialpathology' => 'Notes_CranialPathology',
            'trepanationgeneralnote' => 'trepanationGeneralNote',
            'trepanationpresent' => 'trepanationPresent'
          }
          pair_transforms = {
            'cranialdeformationpresent' => {'special' => 'boolean'},
            'trepanationpresent' => {'special' => 'boolean'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pair_transforms)

          repeats = {
            'cranialdeformationcategory' => ['cranialDeformationCategories', 'cranialDeformationCategory']
          }
          repeat_transforms = {
            'cranialdeformationcategory' => {'vocab' => 'cranialdeformationcategory'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)

          # trepanationGroupList
          trep_data = {
            'trepanationnote' => 'trepanationNote',
            'trepanationcertainty' => 'trepanationCertainty',
            'trepanationlocation' => 'trepanationLocation',
            'trepanationdimensionmin' => 'trepanationDimensionMin',
            'trepanationtechnique' => 'trepanationTechnique',
            'trepanationhealing' => 'trepanationHealing',
            'trepanationdimensionmax' => 'trepanationDimensionMax'
          }
          trep_transforms = {
            'trepanationcertainty' => {'vocab' => 'trepanationcertainty'},
            'trepanationtechnique' => {'vocab' => 'trepanationtechnique'},
            'trepanationhealing' => {'vocab' => 'trepanationhealing'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'trepanation',
            trep_data,
            trep_transforms
          )
          
        end

        def self.map(xml, attributes)
          pairs = {
            'inventoryid' => 'InventoryID',
            'mortuarytreatment' => 'mortuaryTreatment',
            'behrensmeyersinglelower' => 'behrensmeyerSingleLower',
            'behrensmeyerupper' => 'behrensmeyerUpper',
            'completeness' => 'completeness',
            'dentitionnote' => 'dentitionNote',
            'dentitionscore' => 'dentitionScore',
            'notesonelementinventory' => 'NotesOnElementInventory',
            'pathologynote' => 'pathologyNote',
            'inventorydate' => 'inventoryDate',
            'mortuarytreatmentnote' => 'mortuaryTreatmentNote',
            'completenessnote' => 'completenessNote',
            'inventoryiscomplete' => 'InventoryIsComplete',
            'molarspresent' => 'molarsPresent',
            'inventoryanalyst' => 'inventoryAnalyst'
          }
          pair_transforms = {
            'mortuarytreatment' => {'vocab' => 'mortuarytreatment'},
            'behrensmeyersinglelower' => {'special' => 'behrensmeyer_translate',
                                          'vocab' => 'behrensmeyer'},
            'behrensmeyerupper' => {'special' => 'behrensmeyer_translate',
                                          'vocab' => 'behrensmeyer'},
            'completeness' => {'vocab' => 'osteocompleteness'},
            'dentitionscore' => {'vocab' => 'dentitionscore'},
            'inventorydate' => {'special' => 'unstructured_date_stamp'},
            'inventoryiscomplete' => {'special' => 'boolean'},
            'molarspresent' => {'special' => 'boolean'},
            'inventoryanalyst' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pair_transforms)

          # osteoAgeEstimateGroupList
          osteoagedata = {
            'osteoageestimateverbatim' => 'osteoAgeEstimateVerbatim',
            'osteoageestimatelower' => 'osteoAgeEstimateLower',
            'osteoageestimateupper' => 'osteoAgeEstimateUpper',
            'osteoageestimateanalyst' => 'osteoAgeEstimateAnalyst',
            'osteoageestimatenote' => 'osteoAgeEstimateNote',
            'osteoageestimatedate' => 'osteoAgeEstimateDate'
          }
          osteoage_transforms = {
            'osteoageestimateanalyst' => {'authority' => ['personauthorities', 'person']}
          }

          CSXML.add_group_list_with_structured_date(
            xml,
            attributes,
            'osteoAgeEstimate',
            osteoagedata,
            'osteoAgeEstimateDate',
            osteoage_transforms,
            subgroup_suffix: 'Group'
          )

          # sexDeterminationGroupList
          sd_data = {
            'sexdetermination' => 'sexDetermination',
            'sexdeterminationdate' => 'sexDeterminationDate',
            'sexdeterminationanalyst' => 'sexDeterminationAnalyst',
            'sexdeterminationnote' => 'sexDeterminationNote'
          }
          sd_transforms = {
            'sexdeterminationanalyst' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_group_list_with_structured_date(
            xml,
            attributes,
            'sexDetermination',
            sd_data,
            'sexDeterminationDate',
            sd_transforms,
            subgroup_suffix: 'Group'
          )
          
        end
      end
    end
  end
end
