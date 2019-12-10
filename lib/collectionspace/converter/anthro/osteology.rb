# frozen_string_literal: true

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
          CSXML.add xml, 'Notes_DentalPathology', attributes['notes_dentalpathology']
          CSXML.add xml, 'Notes_CranialPathology', attributes['notes_cranialpathology']
          CSXML.add xml, 'Notes_PostcranialPathology', attributes['notes_postcranialpathology']
          CSXML.add xml, 'Notes_CulturalModifications', attributes['notes_culturalmodifications']
          CSXML.add xml, 'Notes_NHTaphonomicAlterations', attributes['notes_nhtaphonomicalterations']
          CSXML.add xml, 'Notes_CuratorialSuffixing', attributes['notes_curatorialsuffixing']
          CSXML.add xml, 'cranialDeformationPresent', attributes['cranialdeformationpresent']
          cranial_deform = []
          deform_cat = CSDR.split_mvf attributes, 'cranialdeformationcategory'
          deform_cat.each_with_index do |dfct, index|
            cranial_deform << {"cranialDeformationCategory" => CSXML::Helpers.get_vocab('cranialdeformationcategory', dfct)}
          end
          CSXML.add_repeat xml, 'cranialDeformationCategories', cranial_deform
          CSXML.add xml, 'cranialDeformationNote', attributes['cranialdeformationnote']
          CSXML.add xml, 'trepanationPresent', attributes['trepanationpresent']
          overall_trepanation = []
          trepanation_location = CSDR.split_mvf attributes, 'trepanationlocation'
          trepanation_certainty = CSDR.split_mvf attributes, 'trepanationcertainty'
          dim_max = CSDR.split_mvf attributes, 'trepanationdimensionmax'
          dim_min = CSDR.split_mvf attributes, 'trepanationdimensionmin'
          trepanation_technique = CSDR.split_mvf attributes, 'trepanationtechnique'
          trepanation_healing = CSDR.split_mvf attributes, 'trepanationhealing'
          trepanation_note = CSDR.split_mvf attributes, 'trepanationnote'
          trepanation_location.each_with_index do |trplc, index|
            overall_trepanation << {"trepanationLocation" => trplc, "trepanationCertainty" => CSXML::Helpers.get_vocab('trepanationcertainty', trepanation_certainty[index]), "trepanationDimensionMax" => dim_max[index], "trepanationDimensionMin" => dim_min[index], "trepanationTechnique" => CSXML::Helpers.get_vocab('trepanationtechnique', trepanation_technique[index]), "trepanationHealing" => CSXML::Helpers.get_vocab('trepanationhealing', trepanation_healing[index]), "trepanationNote" => trepanation_note[index]}
          end
          CSXML.add_group_list xml, 'trepanation', overall_trepanation
          CSXML.add xml, 'trepanationGeneralNote', attributes['trepanationgeneralnote']
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'InventoryID', attributes['inventoryid']
          osteoageestimate = []
          verbatim = CSDR.split_mvf attributes, 'osteoageestimateverbatim'
          age_lower = CSDR.split_mvf attributes, 'osteoageestimatelower'
          age_upper = CSDR.split_mvf attributes, 'osteoageestimateupper'
          age_analyst = CSDR.split_mvf attributes, 'osteoageestimateanalyst'
          age_note = CSDR.split_mvf attributes, 'osteoageestimatenote'

          verbatim.each_with_index do |vbtm, index|
            osteoageestimate << {"osteoAgeEstimateVerbatim" => vbtm, "osteoAgeEstimateLower" => age_lower[index], "osteoAgeEstimateUpper" => age_upper[index], "osteoAgeEstimateAnalyst" =>  CSXML::Helpers.get_authority('personauthorities', 'person', age_analyst[index]), "osteoAgeEstimateNote" => age_note}
          end 
          CSXML.add_group_list xml, 'osteoAgeEstimate', osteoageestimate
          sexdetermination = []
          sex_determination = CSDR.split_mvf attributes, 'sexdetermination'
          determination_analyst = CSDR.split_mvf attributes, 'sexdeterminationanalyst'
          determination_note = CSDR.split_mvf attributes, 'sexdeterminationnote'
          sex_determination.each_with_index do |sxd, index|
            sexdetermination << {"sexDetermination" => sxd, "sexDeterminationAnalyst" => CSXML::Helpers.get_authority('personauthorities', 'person', determination_analyst[index]), "sexDeterminationNote" => determination_note[index]}
          end 
          CSXML.add_group_list xml, 'sexDetermination', sexdetermination
          CSXML.add xml, 'completeness', CSXML::Helpers.get_vocab('osteocompleteness',  attributes['completeness'])
          CSXML.add xml, 'completenessNote', attributes['completenessnote']
          CSXML.add xml, 'molarsPresent', attributes['molarspresent']
          CSXML.add xml, 'dentitionScore', CSXML::Helpers.get_vocab('dentitionscore',  attributes['dentitionscore'])
          CSXML.add xml, 'dentitionNote', attributes['dentitionnote']
          CSXML.add xml, 'mortuaryTreatment', CSXML::Helpers.get_vocab('mortuarytreatment',  attributes['mortuarytreatment'])
          CSXML.add xml, 'mortuaryTreatmentNote', attributes['mortuarytreatmentnote']
          CSXML.add xml, 'behrensmeyerSingleLower', CSXML::Helpers.get_vocab('behrensmeyer',  attributes['behrensmeyersinglelower'])
          CSXML.add xml, 'behrensmeyerUpper', CSXML::Helpers.get_vocab('behrensmeyer',  attributes['behrensmeyerupper'])
          CSXML.add xml, 'NotesOnElementInventory', attributes['notesonelementinventory']
          CSXML.add xml, 'pathologyNote', attributes['pathologynote']
          CSXML.add xml, 'InventoryIsComplete', attributes['inventoryiscomplete']
          CSXML.add xml, 'inventoryAnalyst', CSXML::Helpers.get_authority('personauthorities', 'person',  attributes['inventoryanalyst'])
          CSXML.add xml, 'inventoryDate', CSDTP.parse(attributes['inventorydate']).earliest_scalar
        end
      end
    end
  end
end
