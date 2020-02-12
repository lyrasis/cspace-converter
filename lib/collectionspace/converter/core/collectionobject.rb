module CollectionSpace
  module Converter
    module Core
      class CoreCollectionObject < CollectionObject
        ::CoreCollectionObject = CollectionSpace::Converter::Core::CoreCollectionObject
        def convert
          run do |xml|
            CoreCollectionObject.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          pairs = {
            'objectnumber' => 'objectNumber',
            'numberofobjects' => 'numberOfObjects',
            'collection' => 'collection',
            'recordstatus' => 'recordStatus',
            'copynumber' => 'copyNumber',
            'editionnumber' => 'editionNumber',
            'phase' => 'phase',
            'sex' => 'sex',
            'objectproductionnote' => 'objectProductionNote',
            'fieldcollectionnote' => 'fieldCollectionNote',
            'fieldcollectionfeature' => 'fieldCollectionFeature',
            'distinguishingfeatures' => 'distinguishingFeatures',
            'agequalifier' => 'ageQualifier',
            'age' => 'age',
            'ageunit' => 'ageUnit',
            'physicaldescription' => 'physicalDescription',
            'objecthistorynote' => 'objectHistoryNote',
            'ownershipaccess' => 'ownershipAccess',
            'ownershipcategory' => 'ownershipCategory',
            'ownershipplace' => 'ownershipPlace',
            'ownershipexchangemethod' => 'ownershipExchangeMethod',
            'ownershipexchangenote' => 'ownershipExchangeNote',
            'ownershipexchangepricecurrency' => 'ownershipExchangePriceCurrency',
            'ownershipexchangepricevalue' => 'ownershipExchangePriceValue',
            'contentdescription' => 'contentDescription',
            'contentdategroup' => 'contentDateGroup',
            'contentnote' => 'contentNote',
            'assoceventname' => 'assocEventName',
            'assoceventnametype' => 'assocEventNameType',
            'assoceventnote' => 'assocEventNote',
            'ownerspersonalexperience' => 'ownersPersonalExperience',
            'ownerspersonalresponse' => 'ownersPersonalResponse',
            'ownerscontributionnote' => 'ownersContributionNote',
            'viewersrole' => 'viewersRole',
            'viewerspersonalexperience' => 'viewersPersonalExperience',
            'viewerspersonalresponse' => 'viewersPersonalResponse',
            'viewerscontributionnote' => 'viewersContributionNote',
            'fieldcollectiondategroup' => 'fieldCollectionDateGroup',
            'fieldcollectionplace' => 'fieldCollectionPlace',
            'fieldcollectionnumber' => 'fieldCollectionNumber'
          }
          pairs_transforms = {
            'agequalifier' => {'vocab' => 'agequalifier'},
            'ownershipexchangepricecurrency' => {'vocab' => 'currency'},
            'contentdategroup' => {'special' => 'structured_date'},
            'fieldcollectiondategroup' => {'special' => 'structured_date'},
            'fieldcollectionplace' => {'authority' => ['placeauthorities', 'place']}
          }
          CSXML::Helpers.add_title(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
          repeats = {
            'briefdescription' => ['briefDescriptions', 'briefDescription'],
            'comments' => ['comments', 'comment'],
            'fieldcollectioneventname' => ['fieldColEventNames', 'fieldColEventName'],
            'form' => ['forms', 'form'],
            'responsibledepartment' => ['responsibleDepartments', 'responsibleDepartment'],
            'style' => ['styles', 'style'],
            'color' => ['colors', 'color'],
            'objectstatus' => ['objectStatusList', 'objectStatus'],
            'contentperson' => ['contentPersons', 'contentPerson'],
            'inventorystatus' => ['inventoryStatusList', 'inventoryStatus'],
            'publishto' => ['publishToList', 'publishTo'],
            'objectproductionreason' => ['objectProductionReasons', 'objectProductionReason'],
            'objectproductiondate' => ['objectProductionDateGroupList', 'objectProductionDateGroup'],
            'ownerperson' => ['owners', 'owner'],
            'ownerorganization' => ['owners', 'owner'],
            'ownershipdate' => ['ownershipDateGroupList', 'ownershipDateGroup'],
            'contentpeople' => ['contentPeoples', 'contentPeople'],
            'contentplace' => ['contentPlaces', 'contentPlace'],
            'contentscript' => ['contentScripts', 'contentScript'],
            'contentorganization' => ['contentOrganizations', 'contentOrganization'],
            'contentlanguage' => ['contentLanguages', 'contentLanguage'],
            'contentactivity' => ['contentActivities', 'contentActivity'],
            'contentposition' => ['contentPositions', 'contentPosition'], 
            'contentconceptassociated' => ['contentConcepts', 'contentConcept'],
            'contentconceptmaterial' => ['contentConcepts', 'contentConcept'],
            'assoceventorganization' => ['assocEventOrganizations', 'assocEventOrganization'],
            'assoceventpeople' => ['assocEventPeoples', 'assocEventPeople'],
            'assoceventperson' => ['assocEventPersons', 'assocEventPerson'],
            'assoceventplace' => ['assocEventPlaces', 'assocEventPlace'],
            'ownersreference' => ['ownersReferences', 'ownersReference'],
            'viewersreference' => ['viewersReferences', 'viewersReference'],
            'fieldcollectionmethod' => ['fieldCollectionMethods', 'fieldCollectionMethod'],
            'fieldcollectionsource' => ['fieldCollectionSources', 'fieldCollectionSource'],
            'fieldcollectorperson' => ['fieldCollectors', 'fieldCollector'],
            'fieldcollectororganization' => ['fieldCollectors', 'fieldCollector']
          }
          repeatstransforms = {
            'contentperson' => {'authority' => ['personauthorities', 'person']},
            'inventorystatus' => {'vocab' => 'inventorystatus'},
            'publishto' => {'vocab' => 'publishto'},
            'objectproductiondate' => {'special' => 'structured_date'},
            'ownerperson' => {'authority' => ['personauthorities', 'person']},
            'ownerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'ownershipdate' => {'special' => 'structured_date'},
            'contentorganization' => {'authority' => ['orgauthorities', 'organization']},
            'contentlanguage' => {'vocab' => 'languages'},
            'contentconceptassociated' => {'authority' => ['conceptauthorities', 'concept']},
            'contentconceptmaterial' => {'authority' => ['conceptauthorities', 'material_ca']},
            'assoceventorganization' => {'authority' => ['orgauthorities', 'organization']},
            'assoceventperson' => {'authority' => ['personauthorities', 'person']},
            'fieldcollectionmethod' => {'vocab' => 'collectionmethod'},
            'fieldcollectionsource' => {'authority' => ['personauthorities', 'person']},
            'fieldcollectorperson' => {'authority' => ['personauthorities', 'person']},
            'fieldcollectororganization' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          #measuredPartGroupList, measuredPartGroup 
          CSXML::Helpers.add_measured_part_group_list(xml, attributes)
          #objectProductionDateGroupList, objectProductionDateGroup 
=begin
          objectproductiondate_data = {
            'objectproductiondate' => 'objectProductionDate',
          }
          objectproductiondate_transforms = {
            'objectproductiondate' => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionDate',
            objectproductiondate_data,
            objectproductiondate_transforms
          )
=end
          #textualInscriptionGroupList,textualInscriptionGroup 
          textualinscriptiondata = {
            'inscriptioncontent' => 'inscriptionContent',
            'inscriptioncontentinscriber' => 'inscriptionContentInscriber',
            'inscriptioncontentlanguage' => 'inscriptionContentLanguage',
            'inscriptioncontentdategroup' => 'inscriptionContentDateGroup',
            'inscriptioncontentposition' => 'inscriptionContentPosition',
            'inscriptioncontentscript' => 'inscriptionContentScript',
            'inscriptioncontenttype' => 'inscriptionContentType',
            'method' => 'inscriptionContentMethod',
            'inscriptioncontentinterpretation' => 'inscriptionContentInterpretation',
            'inscriptioncontenttranslation' => 'inscriptionContentTranslation',
            'inscriptioncontenttransliteration' => 'inscriptionContentTransliteration'
          }
          textualinscriptiontransforms = {
            'inscriptioncontentinscriber' => {'authority' => ['personauthorities', 'person']},
            'inscriptioncontentlanguage' => {'vocab' => 'languages'},
            'inscriptioncontentdategroup' => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'textualInscription',
            textualinscriptiondata,
            textualinscriptiontransforms
          )
          #objectProductionOrganizationGroupList, objectProductionOrganizationGroup
          objectprodorgdata = {
            'objectproductionorganization' => 'objectProductionOrganization',
            'objectproductionorganizationrole' => 'objectProductionOrganizationRole'
          }
          objectprodorgtransforms = {
            'objectproductionorganization' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionOrganization',
            objectprodorgdata,
            objectprodorgtransforms
          )
          #objectProductionPersonGroupList, objectProductionPersonGroup
          objectprodpersondata = {
            'objectproductionperson' => 'objectProductionPerson',
            'objectproductionpersonrole' => 'objectProductionPersonRole'
          }
          objectprodpersontransforms = {
            'objectproductionperson' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPerson',
            objectprodpersondata,
            objectprodpersontransforms
          )
          # not simple because 'objectProductionPeople' singularized as 'objectProductionPerson'
          objectprodpeopledata = {
            'objectproductionpeople' => 'objectProductionPeople',
            'objectproductionpeoplerole' => 'objectProductionPeopleRole'
          } 
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPeople',
            objectprodpeopledata,
          )
          #objectNameList, objectNameGroup
          objectname_data = {
            'objectname' => 'objectName',
            'objectnamecurrency' => 'objectNameCurrency',
            'objectnamelevel' => 'objectNameLevel',
            'objectnamesystem' => 'objectNameSystem',
            'objectnametype' => 'objectNameType',
            'objectnamelanguage' => 'objectNameLanguage',
            'objectnamenote' => 'objectNameNote',
          }
          objectname_transforms = {
            'objectnamelanguage' => {'vocab' => 'languages'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectName',
            objectname_data,
            objectname_transforms,
            list_suffix: 'List'
          )
          #otherNumberList, otherNumber
          othernumber_data = {
            'numbervalue' => 'numberValue',
            'numbertype' => 'numberType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'otherNumber',
            othernumber_data,
            list_suffix: 'List',
            group_suffix: ''
          )
          #objectComponentGroupList, objectComponentGroup
          objectcompdata = {
            'objectcomponentname' => 'objectComponentName',
            'objectcomponentinformation' => 'objectComponentInformation'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectComponent',
            objectcompdata,
          )
          #materialGroupList, materialGroup
          materialdata = {
            'materialname' => 'materialName',
            'material' => 'material',
            'materialcomponent' => 'materialComponent',
            'materialcomponentnote' => 'materialComponentNote',
            'materialsource' => 'materialSource'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'material',
            materialdata
          )
          #technicalAttributeGroupList, technicalAttributeGroup
          techattribute_data = {
            'technicalattribute' => 'technicalAttribute',
            'technicalattributemeasurementunit' => 'technicalAttributeMeasurementUnit',
            'technicalattributemeasurement' => 'technicalAttributeMeasurement'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'technicalAttribute',
            techattribute_data
          )
          #techniqueGroupList, techniqueGroup
          technique_data = {
            'technique' => 'technique',
            'techniquetype' => 'techniqueType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'technique',
            technique_data
          )
          #objectProductionPlaceGroupList, objectProductionPlaceGroup
          prodplace_data = {
            'objectproductionplace' => 'objectProductionPlace',
            'objectproductionplacerole' => 'objectProductionPlaceRole'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPlace',
            prodplace_data
          )
          #usageGroupList, usageGroup
          usage_data = {
            'usage' => 'usage',
            'usagenote' => 'usageNote'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'usage',
            usage_data
          )
          #contentEventNameGroupList, contentEventNameGroup
          contenteventname_data = {
            'contenteventname' => 'contentEventName',
            'contenteventnametype' => 'contentEventNameType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'contentEventName',
            contenteventname_data
          )
          #contentOtherGroupList, contentOtherGroup
          contentother_data = {
            'contentother' => 'contentOther',
            'contentothertype' => 'contentOtherType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'contentOther',
            contentother_data
          )
          #contentObjectGroupList, contentObjectGroup
          contentobject_data = {
            'contentobject' => 'contentObject',
            'contentobjecttype' => 'contentObjectType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'contentObject',
            contentobject_data
          )
          #assocActivityGroupList, assocActivityGroup
          assocactivity_data = {
            'assocactivity' => 'assocActivity',
            'assocactivitytype' => 'assocActivityType',
            'assocactivitynote' => 'assocActivityNote'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocActivity',
            assocactivity_data
          )
          #assocObjectGroupList, assocObjectGroup
          assocobject_data = {
            'assocobject' => 'assocObject',
            'assocobjectnote' => 'assocObjectNote',
            'assocobjecttype' => 'assocObjectType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocObject',
            assocobject_data
          )
          #assocConceptGroupList, assocConceptGroup
          assocconcept_data = {
            'assocconcept' => 'assocConcept',
            'assocconceptnote' => 'assocConceptNote',
            'assocconcepttype' => 'assocConceptType'
          }
          assocconcept_transforms = {
            'assocconcept' => {'authority' => ['conceptauthorities', 'concept']} 
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocConcept',
            assocconcept_data,
            assocconcept_transforms
          )
          #assocCulturalContextGroupList, assocCulturalContextGroup
          assocculturalcontext_data = {
            'assocculturalcontext' => 'assocCulturalContext',
            'assocculturalcontextnote' => 'assocCulturalContextNote',
            'assocculturalcontexttype' => 'assocCulturalContextType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocCulturalContext',
            assocculturalcontext_data
          )
          #assocOrganizationGroupList, assocOrganizationGroup
          assocorganization_data = {
            'assocorganization' => 'assocOrganization',
            'assocorganizationtype' => 'assocOrganizationType',
            'assocorganizationnote' => 'assocOrganizationNote'
          }
          assocorganization_transforms = {
            'assocorganization' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocOrganization',
            assocorganization_data,
            assocorganization_transforms
          )
          #assocPeopleGroupList, assocPeopleGroup
          assocpeople_data = {
            'assocpeople' => 'assocPeople',
            'assocpeoplenote' => 'assocPeopleNote',
            'assocpeopletype' => 'assocPeopleType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocPeople',
            assocpeople_data
          )
          #assocPersonGroupList, assocPersonGroup
          assocperson_data = {
            'assocperson' => 'assocPerson',
            'assocpersontype' => 'assocPersonType',
            'assocpersonnote' => 'assocPersonNote'
          }
          assocperson_transforms = {
            'assocperson' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocPerson',
            assocperson_data,
            assocperson_transforms
          )
          #assocPlaceGroupList, assocPlaceGroup
          assocplace_data = {
            'assocplace' => 'assocPlace',
            'assocplacenote' => 'assocPlaceNote',
            'assocplacetype' => 'assocPlaceType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocPlace',
            assocplace_data
          )
          #assocDateGroupList, assocDateGroup
          assocdate_data = {
            'assocdatenote' => 'assocDateNote',
            'assocdatetype' => 'assocDateType',
            'assocstructureddategroup' => 'assocStructuredDateGroup'
          }
          assocdate_transforms = {
            'assocstructureddategroup' => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocDate',
            assocdate_data,
            assocdate_transforms
          )
          #referenceGroupList, referenceGroup
          referencegroup_data = {
            'reference' => 'reference',
            'referencenote' => 'referenceNote',
          }
          referencegroup_transforms = {
            'reference' => {'authority' => ['citationauthorities', 'citation']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'reference',
            referencegroup_data,
            referencegroup_transforms
          )
        end
      end
    end
  end
end
