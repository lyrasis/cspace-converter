module CollectionSpace
  module Converter
    module Materials
      class MaterialsMaterial < Material
        ::MaterialsMaterial = CollectionSpace::Converter::Materials::MaterialsMaterial
        def convert
          run do |xml|
            MaterialsMaterial.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # materialTerm
          CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["termdisplayname"])
          CSXML.add_group_list xml, 'materialTerm', [
            {
              "termDisplayName" => attributes["termdisplayname"],
              "termType" => CSURN.get_vocab_urn('persontermtype', attributes["termtype"]),
              "termName" => attributes["term_name"],
              "historicalStatus" => attributes["historical_status"],
              "termFlag" => attributes["term_flag"],
              "termLanguage" => attributes["term_language"],
              "termPrefForLang" => attributes["term_pref_for_lang"],
              "termQualifier" => attributes["term_qualifier"],
              "termSource" => attributes["term_source"],
              "termSourceID" => attributes["term_source_id"],
              "termSourceDetail" => attributes["term_source_detail"],
              "termSourceNote" => attributes["term_source_note"],
              "termStatus" => attributes["term_status"],
            }
          ]
          # materialComposition
          CSXML.add_group_list xml, 'materialComposition', [
            {
              "materialCompositionFamilyName" => attributes["material_composition_family_name"],
              "materialCompositionClassName" => attributes["material_composition_class_name"],
              "materialCompositionGenericName" => attributes["material_composition_generic_name"],

            }
          ]
          # description
          CSXML.add xml, 'description', attributes["description"]
          # Discontinued
          CSXML.add_group xml, 'discontinued', { "discontinued" => attributes['birth_date_group'],
            'discontinuedBy' => attributes['discontinued_by'],
            'discontinuedDate' => attributes['discontinued_date'],
            'dateAssociation' => attributes['date_association'],
            'dateEarliestSingleYear' => attributes['date_earliest_single_year'],
            'dateEarliestSingleMonth' => attributes['date_earliest_single_month'],
            'dateEarliestSingleDay' => attributes['date_earliest_single_day'],
            'dateEarliestSingleEra' => attributes['date_earliest_single_era'],
            'dateEarliestSingleCertainty' => attributes['date_earliest_single_certainty'],
            'dateEarliestSingleQualifier' => attributes['date_earliest_single_qualifier'],
            'dateEarliestSingleQualifierValue' => attributes['date_earliest_single_qualifier_value'],
            'DateEarliestSingleQualifierUnit' => attributes['date_earliest_single_qualifier_unit'],
            'dateLatestSingleYear' => attributes['date_latest_single_year'],
            'dateLatestSingleMonth' => attributes['date_latest_single_month'],
            'dateLatestSingleDay' => attributes['date_latest_single_day'],
            'dateLatestSingleEra' => attributes['date_latest_single_era'],
            'dateLatestSingleCertainty' => attributes['date_latest_single_certainty'],
            'dateLatestSingleQualifier' => attributes['date_latest_single_qualifier'],
            'dateLatestSingleQualifierValue' => attributes['date_latest_single_qualifier_value'],
            'DateLatestSingleQualifierUnit' => attributes['date_latest_single_qualifier_unit'],
            'datePeriod' => attributes['date_period'],
            'dateNote' => attributes['date_note'],
          }
          # Production date
          CSXML.add_group xml, 'productionDate', {
            'dateAssociation' => attributes['date_association'],
            'dateEarliestSingleYear' => attributes['date_earliest_single_year'],
            'dateEarliestSingleMonth' => attributes['date_earliest_single_month'],
            'dateEarliestSingleDay' => attributes['date_earliest_single_day'],
            'dateEarliestSingleEra' => attributes['date_earliest_single_era'],
            'dateEarliestSingleCertainty' => attributes['date_earliest_single_certainty'],
            'dateEarliestSingleQualifier' => attributes['date_earliest_single_qualifier'],
            'dateEarliestSingleQualifierValue' => attributes['date_earliest_single_qualifier_value'],
            'DateEarliestSingleQualifierUnit' => attributes['date_earliest_single_qualifier_unit'],
            'dateLatestSingleYear' => attributes['date_latest_single_year'],
            'dateLatestSingleMonth' => attributes['date_latest_single_month'],
            'dateLatestSingleDay' => attributes['date_latest_single_day'],
            'dateLatestSingleEra' => attributes['date_latest_single_era'],
            'dateLatestSingleCertainty' => attributes['date_latest_single_certainty'],
            'dateLatestSingleQualifier' => attributes['date_latest_single_qualifier'],
            'dateLatestSingleQualifierValue' => attributes['date_latest_single_qualifier_value'],
            'DateLatestSingleQualifierUnit' => attributes['date_latest_single_qualifier_unit'],
            'datePeriod' => attributes['date_period'],
            'dateNote' => attributes['date_note'],
          }
          # productionNote
          CSXML.add xml, 'productionNote', attributes["production_note"]
          # materialProductionOrganization
          CSXML.add_group_list xml, 'materialProductionOrganization', [
            {
              "materialProductionOrganization" => attributes["material_production_organization"],
              "materialProductionOrganizationRole" => attributes["material_production_organization_role"],
            }
          ]
          # materialProductionPerson
          CSXML.add_group_list xml, 'materialProductionPerson', [
            {
              "materialProductionPerson" => attributes["material_production_person"],
              "materialProductionPersonRole" => attributes["material_production_person_role"],
            }
          ]
          # materialProductionPlace
          CSXML.add_group_list xml, 'materialProductionPlace', [
            {
              "materialProductionPlace" => attributes["material_production_place"],
              "materialProductionPlaceRole" => attributes["material_production_place_role"],
            }
          ]
          # featuredApplication
          CSXML.add_group_list xml, 'featuredApplication', [
            {
              "featuredApplication" => attributes["featured_application"],
              "featuredApplicationNote" => attributes["featured_application_note"],
            }
          ]
          # materialCitation
          CSXML.add_group_list xml, 'materialCitation', [
            {
              "materialCitationSource" => attributes["material_citation_source"],
              "materialCitationSourceDetail" => attributes["material_citation_source_detail"],
            }
          ]
          # externalUrl
          CSXML.add_group_list xml, 'externalUrl', [
            {
              "externalUrl" => attributes["external_url"],
              "externalUrlNote" => attributes["external_url_note"],
            }
          ]
          # additionalResource
          CSXML.add_group_list xml, 'additionalResource', [
            {
              "additionalResource" => attributes["additional_resource"],
              "additionalResourceNote" => attributes["additional_resource_note"],
            }
          ]
          # materialTermAttributionContributing
          CSXML.add_group_list xml, 'materialTermAttributionContributing', [
            {
              "materialTermAttributionContributingOrganization" => attributes["material_term_attribution_contributing_organization"],
              "materialTermAttributionContributingPerson" => attributes["material_term_attribution_contributing_person"],
              "materialTermAttributionContributingDate" => attributes["material_term_attribution_contributing_date"],
            }
          ]
          # materialTermAttributionEditing
          CSXML.add_group_list xml, 'materialTermAttributionEditing', [
            {
              "materialTermAttributionEditingOrganization" => attributes["material_term_attribution_editing_organization"],
              "materialTermAttributionEditingPerson" => attributes["material_term_attribution_editing_person"],
              "materialTermAttributionEditingNote" => attributes["material_term_attribution_editing_note"],
              "materialTermAttributionEditingDate" => attributes["material_term_attribution_editing_date"],
            }
          ]
          # commonForm
          CSXML.add xml, 'commonForm', attributes["common_form"]
          # formType
          CSXML.add xml, 'formType', attributes["form_type"]
          # typicalSize
          CSXML.add_group_list xml, 'typicalSize', [
            {
              "typicalSize" => attributes["typical_size"],
            }
          ]
          #dimensions
          dimensions = []
          dims = split_mvf attributes, 'dimension'
          values = split_mvf attributes, 'value'
          unit = attributes["unit"]
          dims.each_with_index do |dim, index|
            dimensions << { "dimension" => dim, "value" => values[index], "measurementUnit" => unit }
          end
          CSXML.add_group_list xml, 'dimension', dimensions
          # formNote
          CSXML.add xml, 'formNote', attributes["form_note"]
          # acousticalProperty
          CSXML.add_group_list xml, 'acousticalProperty', [
            {
              "acousticalPropertyType" => attributes["acoustical_property_type"],
              "acousticalPropertyNote" => attributes["acoustical_property_note"],
            }
          ]
          # durabilityProperty
          CSXML.add_group_list xml, 'durabilityProperty', [
            {
              "durabilityPropertyType" => attributes["durability_property_type"],
              "durabilityPropertyNote" => attributes["durability_property_note"],
            }
          ]
          # electricalProperty
          CSXML.add_group_list xml, 'electricalProperty', [
            {
              "electricalPropertyType" => attributes["electrical_property_type"],
              "electricalPropertyNote" => attributes["electrical_property_note"],
            }
          ]
          # hygrothermalProperty
          CSXML.add_group_list xml, 'hygrothermalProperty', [
            {
              "hygrothermalPropertyType" => attributes["hygrothermal_property_type"],
              "hygrothermalPropertyNote" => attributes["hygrothermal_property_note"],
            }
          ]
          # mechanicalProperty
          CSXML.add_group_list xml, 'mechanicalProperty', [
            {
              "mechanicalPropertyType" => attributes["mechanical_property_type"],
              "mechanicalPropertyNote" => attributes["mechanical_property_note"],
            }
          ]
          # opticalProperty
          CSXML.add_group_list xml, 'opticalProperty', [
            {
              "opticalPropertyType" => attributes["optical_property_type"],
              "opticalPropertyNote" => attributes["optical_property_note"],
            }
          ]
          # sensorialProperty
          CSXML.add_group_list xml, 'sensorialProperty', [
            {
              "sensorialPropertyType" => attributes["sensorial_property_type"],
              "sensorialPropertyNote" => attributes["sensorial_property_note"],
            }
          ]
            # smartMaterialProperty
          CSXML.add_group_list xml, 'smartMaterialProperty', [
            {
              "smartMaterialPropertyType" => attributes["smart_material_property_type"],
              "smartMaterialPropertyNote" => attributes["smart_material_property_note"],
            }
          ]
            # additionalProperty
          CSXML.add_group_list xml, 'additionalProperty', [
            {
              "additionalPropertyType" => attributes["additional_property_type"],
              "additionalPropertyNote" => attributes["additional_property_note"],
            }
          ]
          # propertyNote
          CSXML.add xml, 'propertyNote', attributes["property_note"]
          # recycledContent
          CSXML.add_group_list xml, 'recycledContent', [
            {
              "recycledContent" => attributes["recycled_content"],
              "recycledContentHigh" => attributes["recycled_content_high"],
              "recycledContentQualifier" => attributes["recycled_content_qualifier"],

            }
          ]
          # lifecycleComponent
          CSXML.add_group_list xml, 'lifecycleComponent', [
            {
              "lifecycleComponent" => attributes["lifecycle_component"],
              "lifecycleComponentNote" => attributes["lifecycle_component_note"],
            }
          ]
          # embodiedEnergy
          CSXML.add_group_list xml, 'embodiedEnergy', [
            {
              "embodiedEnergyValue" => attributes["embodied_energy_value"],
              "embodiedEnergyValueHigh" => attributes["embodied_energy_value_high"],
              "embodiedEnergyUnit" => attributes["embodied_energy_unit"],
              "embodiedEnergyNote" => attributes["embodied_energy_note"],
            }
          ]
          # certificationCredit
          CSXML.add_group_list xml, 'certificationCredit', [
            {
              "certificationProgram" => attributes["certification_program"],
              "certificationCreditNote" => attributes["certification_credit_note"],
            }
          ]
          # ecologyNote
          CSXML.add xml, 'ecologyNote', attributes["ecology_note"]
          # castingProcess
          CSXML.add xml, 'castingProcess', attributes["casting_process"]
          # deformingProcess
          CSXML.add xml, 'deformingProcess', attributes["deforming_process"]
          # joiningProcess
          CSXML.add xml, 'joiningProcess', attributes["joiningProcess"]
          # machiningProcess
          CSXML.add xml, 'machiningProcess', attributes["machining_process"]
          # moldingProcess
          CSXML.add xml, 'moldingProcess', attributes["molding_process"]
          # rapidPrototypingProcess
          CSXML.add xml, 'rapidPrototypingProcess', attributes["rapid_prototyping_process"]
          # surfacingProcess
          CSXML.add xml, 'surfacingProcess', attributes["surfacing_process"]
          # additionalProcess
          CSXML.add_group_list xml, 'additionalProcess', [
            {
              "additionalProcess" => attributes["additional_process"],
              "additionalProcessNote" => attributes["additional_process_note"],
            }
          ]
          # processNote
          CSXML.add xml, 'processNote', attributes["process_note"]
        end
      end
    end
  end
end
