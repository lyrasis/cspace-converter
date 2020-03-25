module CollectionSpace
  module Converter
    module Materials
      class MaterialsMaterial < Material
        ::MaterialsMaterial = CollectionSpace::Converter::Materials::MaterialsMaterial
        def convert
          run do |xml|
            MaterialsMaterial.map(xml, attributes, config)
          end
        end

        def self.map(xml, attributes, config)
          pairs = {
            'description' => 'description',
            'discontinued' => 'discontinued',
            'commonform' => 'commonForm',
            'formnote' => 'formNote',
            'propertynote' => 'propertyNote',
            'ecologynote' => 'ecologyNote',
            'processnote' => 'processNote',
            'discontinuedby' => 'discontinuedBy',
            'productionnote' => 'productionNote'
          }
          pairstransforms = {
            'commonform' => {'vocab' => 'materialform'},
            'discontinuedby' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
 
          repeats = { 
            'typicaluse' => ['typicalUses', 'typicalUse'],
            'castingprocess' => ['castingProcesses', 'castingProcess'],
            'deformingprocess' => ['deformingProcesses', 'deformingProcess'],
            'joiningprocess' => ['joiningProcesses', 'joiningProcess'],
            'machiningprocess' => ['machiningProcesses', 'machiningProcess'],
            'moldingprocess' => ['moldingProcesses', 'moldingProcess'],
            'rapidprototypingprocess' => ['rapidPrototypingProcesses', 'rapidPrototypingProcess'],
            'surfacingprocess' => ['surfacingProcesses', 'surfacingProcess'],
            'publishto' => ['publishToList', 'publishTo']
          }
          repeatstransforms = {
            'typicaluse' => {'vocab' => 'materialuse'},
            'castingprocess' => {'vocab' => 'castingprocesses'},
            'deformingprocess' => {'vocab' => 'deformingprocesses'},
            'joiningprocess' => {'vocab' => 'joiningprocesses'},
            'machiningprocess' => {'vocab' => 'machiningprocesses'},
            'moldingprocess' => {'vocab' => 'moldingprocesses'},
            'rapidprototypingprocess' => {'vocab' => 'rapidprototypingprocesses'},
            'surfacingprocess' => {'vocab' => 'surfacingprocesses'},
            'publishto' => {'vocab' => 'publishto'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          CSXML::Helpers.add_date_group(xml, 'productionDate', CSDTP.parse(attributes['productiondate']), suffix = '')
          CSXML::Helpers.add_date_group(xml, 'discontinuedDate', CSDTP.parse(attributes['discontinueddate']), suffix = '')
          CSXML.add xml, 'shortIdentifier', config[:identifier]
          # materialTermGroupList, materialTermGroup
          materialterm_data = {
            'historicalstatus' => 'historicalStatus',
            'termdisplayname' => 'termDisplayName',
            'termname' => 'termName',
            'termflag' => 'termFlag',
            'termlanguage' => 'termLanguage',
            'termprefforlang' => 'termPrefForLang',
            'termqualifier' => 'termQualifier',
            'termsource' => 'termSource',
            'termsourceid' => 'termSourceID',
            'termsourcedetail' => 'termSourceDetail',
            'termsourcenote' => 'termSourceNote',
            'termstatus' => 'termStatus',
            'termtype' => 'termType'
          }
          materialterm_transforms = {
            'termflag' => {'vocab' => 'materialtermflag'},
            'termlanguage' => {'vocab' => 'languages'},
            'termsource' => {'authority' => ['citationauthorities', 'citation']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'materialTerm',
            materialterm_data,
            materialterm_transforms
          )
          #materialCompositionGroupList, materialCompositionGroup
          materialcomposition_data = {
            'materialcompositionfamilyname' => 'materialCompositionFamilyName',
            'materialcompositionclassname' => 'materialCompositionClassName',
            'materialcompositiongenericname' => 'materialCompositionGenericName'
          }
          materialcomposition_transforms = {
            'materialcompositionfamilyname' => {'authority' => ['conceptauthorities', 'materialclassification']},
            'materialcompositionclassname' => {'authority' => ['conceptauthorities', 'materialclassification']},
            'materialcompositiongenericname' => {'authority' => ['conceptauthorities', 'materialclassification']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'materialComposition',
            materialcomposition_data,
            materialcomposition_transforms
          )
          #materialProductionOrganizationGroupList, materialProductionOrganizationGroup
          materialprodorg_data = {
            'materialproductionorganization' => 'materialProductionOrganization',
            'materialproductionorganizationrole' => 'materialProductionOrganizationRole'
          }
          materialprodorg_transforms = {
            'materialproductionorganization' => {'authority' => ['orgauthorities', 'organization']},
            'materialproductionorganizationrole' => {'vocab' => 'materialproductionrole'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'materialProductionOrganization',
            materialprodorg_data,
            materialprodorg_transforms
          )
          #materialProductionPersonGroupList, materialProductionPersonGroup
          materialprodperson_data = {
            'materialproductionperson' => 'materialProductionPerson',
            'materialproductionpersonrole' => 'materialProductionPersonRole'
          }
          materialprodperson_transforms = {
            'materialproductionperson' => {'authority' => ['personauthorities', 'person']},
            'materialproductionpersonrole' => {'vocab' => 'materialproductionrole'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'materialProductionPerson',
            materialprodperson_data,
            materialprodperson_transforms
          )
          #materialProductionPlaceGroupList, materialProductionPlaceGroup
          materialprodplace_data = {
            'materialproductionplace' => 'materialProductionPlace',
            'materialproductionplacerole' => 'materialProductionPlaceRole'
          }
          materialprodplace_transforms = {
            'materialproductionplace' => {'authority' => ['placeauthorities', 'place']},
            'materialproductionplacerole' => {'vocab' => 'materialproductionrole'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'materialProductionPlace',
            materialprodplace_data,
            materialprodplace_transforms
          )
          #featuredApplicationGroupList, featuredApplicationGroup
          featuredapp_data = {
            'featuredapplication' => 'featuredApplication',
            'featuredapplicationnote' => 'featuredApplicationNote'
          }
          featuredapp_transforms = {
            'featuredapplication' => {'authority' => ['workauthorities', 'work']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'featuredApplication',
            featuredapp_data,
            featuredapp_transforms
          )
          #materialCitationGroupList, materialCitationGroup
          materialcitation_data = {
            'materialcitationsource' => 'materialCitationSource',
            'materialcitationsourcedetail' => 'materialCitationSourceDetail'
          }
          materialcitation_transforms = {
            'materialcitationsource' => {'authority' => ['citationauthorities', 'citation']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'materialCitation',
            materialcitation_data,
            materialcitation_transforms
          )
          #externalUrlGroupList, externalUrlGroup
          exturl_data = {
            'externalurl' => 'externalUrl',
            'externalurlnote' => 'externalUrlNote'
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'externalUrl',
            exturl_data
          )
          #additionalResourceGroupList, additionalResourceGroup
          additionalresource_data = {
            'additionalresource' => 'additionalResource',
            'additionalresourcenote' => 'additionalResourceNote'
          }
          additionalresource_transforms = {
            'additionalresource' => {'vocab' => 'materialresource'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'additionalResource',
            additionalresource_data,
            additionalresource_transforms
          )
          #materialTermAttributionContributingGroupList, materialTermAttributionContributingGroup
          materialattcontrib_data = {
            'materialtermattributioncontributingorganization' => 'materialTermAttributionContributingOrganization',
            'materialtermattributioncontributingperson' => 'materialTermAttributionContributingPerson',
            'materialtermattributioncontributingdate' => 'materialTermAttributionContributingDate',
          }
          materialattcontrib_transforms = {
            'materialtermattributioncontributingorganization' => {'authority' => ['orgauthorities', 'organization']},
            'materialtermattributioncontributingperson' => {'authority' => ['personauthorities', 'person']},
            'materialtermattributioncontributingdate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'materialTermAttributionContributing',
            materialattcontrib_data,
            materialattcontrib_transforms
          )
          #materialTermAttributionEditingGroupList, materialTermAttributionEditingGroup
          materialattediting_data = {
            'materialtermattributioneditingorganization' => 'materialTermAttributionEditingOrganization',
            'materialtermattributioneditingperson' => 'materialTermAttributionEditingPerson',
            'materialtermattributioneditingdate' => 'materialTermAttributionEditingDate',
            'materialtermattributioneditingnote' => 'materialTermAttributionEditingNote'
          }
          materialattediting_transforms = {
            'materialtermattributioneditingorganization' => {'authority' => ['orgauthorities', 'organization']},
            'materialtermattributioneditingperson' => {'authority' => ['personauthorities', 'person']},
            'materialtermattributioneditingdate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'materialTermAttributionEditing',
            materialattediting_data,
            materialattediting_transforms
          )
          # formTypeGroupList, formTypeGroup
          formtype_data = {
            'formtype' => 'formType',
          }
          formtype_transforms = {
            'formtype' => {'vocab' => 'materialformtype'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'formType',
            formtype_data,
            formtype_transforms
          )
          #typicalSizeGroupList, typicalSizeGroup, typicalSizeDimensionGroupList, typicalSizeDimensionGroup
          CSXML::Helpers.add_typical_size_group_list(xml, attributes)
          #acousticalPropertyGroupList, acousticalPropertyGroup
          acousticalproperty_data = {
            'acousticalpropertytype' => 'acousticalPropertyType',
            'acousticalpropertynote' => 'acousticalPropertyNote'
          }
          acousticalproperty_transforms = {
            'acousticalpropertytype' => {'vocab' => 'acousticalproperties'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'acousticalProperty',
            acousticalproperty_data,
            acousticalproperty_transforms
          )
          #durabilityPropertyGroupList, durabilityPropertyGroup
          durabilityproperty_data = {
            'durabilitypropertytype' => 'durabilityPropertyType',
            'durabilitypropertynote' => 'durabilityPropertyNote'
          }
          durabilityproperty_transforms = {
            'durabilitypropertytype' => {'vocab' => 'durabilityproperties'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'durabilityProperty',
            durabilityproperty_data,
            durabilityproperty_transforms
          )
          #electricalPropertyGroupList, electricalPropertyGroup
          electricalproperty_data = {
            'electricalpropertytype' => 'electricalPropertyType',
            'electricalpropertynote' => 'electricalPropertyNote'
          }
          electricalproperty_transforms = {
            'electricalpropertytype' => {'vocab' => 'electricalproperties'}
          } 
          CSXML.add_single_level_group_list(
            xml, attributes,
            'electricalProperty',
            electricalproperty_data,
            electricalproperty_transforms
          )
          #hygrothermalPropertyGroupList, hygrothermalPropertyGroup
          hygrothermalproperty_data = {
            'hygrothermalpropertytype' => 'hygrothermalPropertyType',
            'hygrothermalpropertynote' => 'hygrothermalPropertyNote'
          }
          hygrothermalproperty_transforms = {
            'hygrothermalpropertytype' => {'vocab' => 'hygrothermalproperties'}
          } 
          CSXML.add_single_level_group_list(
            xml, attributes,
            'hygrothermalProperty',
            hygrothermalproperty_data,
            hygrothermalproperty_transforms
          )
          #mechanicalPropertyGroupList, mechanicalPropertyGroup
          mechanicalproperty_data = {
            'mechanicalpropertytype' => 'mechanicalPropertyType',
            'mechanicalpropertynote' => 'mechanicalPropertyNote'
          }
          mechanicalproperty_transforms = {
            'mechanicalpropertytype' => {'vocab' => 'mechanicalproperties'}
          } 
          CSXML.add_single_level_group_list(
            xml, attributes,
            'mechanicalProperty',
            mechanicalproperty_data,
            mechanicalproperty_transforms
          )
          #opticalPropertyGroupList, opticalPropertyGroup
          opticalproperty_data = {
            'opticalpropertytype' => 'opticalPropertyType',
            'opticalpropertynote' => 'opticalPropertyNote'
          }
          opticalproperty_transforms = {
            'opticalpropertytype' => {'vocab' => 'opticalproperties'}
          } 
          CSXML.add_single_level_group_list(
            xml, attributes,
            'opticalProperty',
            opticalproperty_data,
            opticalproperty_transforms
          )
          #sensorialPropertyGroupList, sensorialPropertyGroup
          sensorialproperty_data = {
            'sensorialpropertytype' => 'sensorialPropertyType',
            'sensorialpropertynote' => 'sensorialPropertyNote'
          }
          sensorialproperty_transforms = {
            'sensorialpropertytype' => {'vocab' => 'sensorialproperties'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'sensorialProperty',
            sensorialproperty_data,
            sensorialproperty_transforms
          )
          #smartMaterialPropertyGroupList, smartMaterialPropertyGroup
          smartproperty_data = {
            'smartmaterialpropertytype' => 'smartMaterialPropertyType',
            'smartmaterialpropertynote' => 'smartMaterialPropertyNote'
          }
          smartproperty_transforms = {
            'smartmaterialpropertytype' => {'vocab' => 'smartmaterialproperties'}
          } 
          CSXML.add_single_level_group_list(
            xml, attributes,
            'smartMaterialProperty',
            smartproperty_data,
            smartproperty_transforms
          )
          #additionalPropertyGroupList, additionalPropertyGroup
          additionalproperty_data = {
            'additionalpropertytype' => 'additionalPropertyType',
            'additionalpropertynote' => 'additionalPropertyNote'
          }
          additionalproperty_transforms = {
            'additionalpropertytype' => {'vocab' => 'additionalproperties'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'additionalProperty',
            additionalproperty_data,
            additionalproperty_transforms
          )
          #recycledContentGroupList, recycledContentGroup
          recycledcontent_data = {
            'recycledcontent' => 'recycledContent',
            'recycledcontenthigh' => 'recycledContentHigh',
            'recycledcontentqualifier' => 'recycledContentQualifier'
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'recycledContent',
            recycledcontent_data
          )
          #lifecycleComponentGroupList, lifecycleComponentGroup
          lifecyclecomponent_data = {
            'lifecyclecomponent' => 'lifecycleComponent',
            'lifecyclecomponentnote' => 'lifecycleComponentNote'
          }
          lifecyclecomponent_transforms = {
            'lifecyclecomponent' => {'vocab' => 'lifecyclecomponents'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'lifecycleComponent',
            lifecyclecomponent_data,
            lifecyclecomponent_transforms
          )
          #embodiedEnergyGroupList, embodiedEnergyGroup
          embodiedenergy_data = {
            'embodiedenergyvalue' => 'embodiedEnergyValue',
            'embodiedenergyvaluehigh' => 'embodiedEnergyValueHigh',
            'embodiedenergyunit' => 'embodiedEnergyUnit',
            'embodiedenergynote' => 'embodiedEnergyNote'
          }
          embodiedenergy_transforms = {
            'embodiedenergyunit' => {'vocab' => 'energyunits'}
          } 
          CSXML.add_single_level_group_list(
            xml, attributes,
            'embodiedEnergy',
            embodiedenergy_data,
            embodiedenergy_transforms
          )
          #certificationCreditGroupList, certificationCreditGroup
          certificationcredit_data = {
            'certificationprogram' => 'certificationProgram',
            'certificationcreditnote' => 'certificationCreditNote',
          }
          certificationcredit_transforms = {
            'certificationprogram' => {'vocab' => 'ecologicalcertifications'}
          } 
          CSXML.add_single_level_group_list(
            xml, attributes,
            'certificationCredit',
            certificationcredit_data,
            certificationcredit_transforms
          )
          #additionalProcessGroupList, additionalProcessGroup
          additionalprocess_data = {
            'additionalprocess' => 'additionalProcess',
            'additionalprocessnote' => 'additionalProcessNote',
          }
          additionalprocess_transforms = {
            'additionalprocess' => {'vocab' => 'additionalprocesses'}
          } 
          CSXML.add_single_level_group_list(
            xml, attributes,
            'additionalProcess',
            additionalprocess_data,
            additionalprocess_transforms
          )
        end
      end
    end
  end
end
