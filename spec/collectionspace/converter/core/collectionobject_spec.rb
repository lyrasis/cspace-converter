require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreCollectionObject do
  let(:attributes) { get_attributes('core', 'cataloging_core_excerpt.csv') }
  let(:corecollectionobject) { CoreCollectionObject.new(attributes) }
  let(:doc) { Nokogiri::XML(corecollectionobject.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_collectionobject.xml') }

  context 'non-authority/vocab fields' do
    [
    '/document/*/objectNumber',
    '/document/*/numberOfObjects',
    '/document/*/titleGroupList/titleGroup/title',    
    '/document/*/titleGroupList/titleGroup/titleType',
    '/document/*/titleGroupList/titleGroup/titleTranslationSubGroupList/titleTranslationSubGroup/titleTranslation',
    '/document/*/collection',
    '/document/*/objectNameList/objectNameGroup/objectName',
    '/document/*/objectNameList/objectNameGroup/objectNameType',
    '/document/*/objectNameList/objectNameGroup/objectNameSystem',
    '/document/*/objectNameList/objectNameGroup/objectNameCurrency',
    '/document/*/objectNameList/objectNameGroup/objectNameNote',
    '/document/*/objectNameList/objectNameGroup/objectNameLevel',
    '/document/*/briefDescriptions/briefDescription',
    '/document/*/responsibleDepartments/responsibleDepartment',
    '/document/*/recordStatus',
    '/document/*/comments/comment',
    '/document/*/fieldColEventNames/fieldColEventName',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSummary',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/dimension',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/value',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measurementUnit',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/valueQualifier',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/valueDate',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measurementMethod',
    '/document/*/measuredPartGroupList/measuredPartGroup/measuredPart',
    '/document/*/copyNumber',
    '/document/*/editionNumber',
    '/document/*/forms/form',
    '/document/*/objectStatusList/objectStatus',
    '/document/*/otherNumberList/otherNumber/numberValue',
    '/document/*/otherNumberList/otherNumber/numberType',
    '/document/*/assocPeopleGroupList/assocPeopleGroup/assocPeople',
    '/document/*/assocPeopleGroupList/assocPeopleGroup/assocPeopleType',
    '/document/*/assocPeopleGroupList/assocPeopleGroup/assocPeopleNote',
    '/document/*/phase',
    '/document/*/sex',
    '/document/*/objectProductionNote',
    '/document/*/fieldCollectionNote',
    '/document/*/fieldCollectionFeature',
    '/document/*/styles/style',
    '/document/*/technicalAttributeGroupList/technicalAttributeGroup/technicalAttribute',
    '/document/*/technicalAttributeGroupList/technicalAttributeGroup/technicalAttributeMeasurementUnit',
    '/document/*/technicalAttributeGroupList/technicalAttributeGroup/technicalAttributeMeasurement',
    '/document/*/objectComponentGroupList/objectComponentGroup/objectComponentName',
    '/document/*/objectComponentGroupList/objectComponentGroup/objectComponentInformation',
    #'/document/*/objectProductionDateGroupList/objectProductionDateGroup',
    '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup/objectProductionPersonRole',
    '/document/*/contentPeoples/contentPeople',
    '/document/*/contentPlaces/contentPlace',
    '/document/*/contentScripts/contentScript',
    '/document/*/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentMethod',
    '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup/objectProductionOrganizationRole',
    '/document/*/techniqueGroupList/techniqueGroup/technique',
    '/document/*/techniqueGroupList/techniqueGroup/techniqueType',
    '/document/*/objectProductionPeopleGroupList/objectProductionPeopleGroup/objectProductionPeople',
    '/document/*/objectProductionPeopleGroupList/objectProductionPeopleGroup/objectProductionPeopleRole',
    '/document/*/objectProductionPlaceGroupList/objectProductionPlaceGroup/objectProductionPlace',
    '/document/*/objectProductionPlaceGroupList/objectProductionPlaceGroup/objectProductionPlaceRole',
    '/document/*/distinguishingFeatures',
    '/document/*/contentEventNameGroupList/contentEventNameGroup/contentEventName',
    '/document/*/contentEventNameGroupList/contentEventNameGroup/contentEventNameType',
    '/document/*/contentOtherGroupList/contentOtherGroup/contentOtherType',
    '/document/*/contentOtherGroupList/contentOtherGroup/contentOther',
    '/document/*/contentDescription',
    '/document/*/contentActivities/contentActivity',
    #'/document/*/contentDateGroup',
    '/document/*/contentPositions/contentPosition',
    '/document/*/contentObjectGroupList/contentObjectGroup/contentObjectType',
    '/document/*/contentObjectGroupList/contentObjectGroup/contentObject',
    '/document/*/contentNote',
    '/document/*/age',
    '/document/*/ageUnit',
    '/document/*/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentMethod',
    '/document/*/materialGroupList/materialGroup/materialName',
    '/document/*/materialGroupList/materialGroup/material',
    '/document/*/materialGroupList/materialGroup/materialComponent',
    '/document/*/materialGroupList/materialGroup/materialComponentNote',
    '/document/*/materialGroupList/materialGroup/materialSource',
    '/document/*/physicalDescription',
    '/document/*/colors/color',
    '/document/*/objectProductionReasons/objectProductionReason',
    '/document/*/assocActivityGroupList/assocActivityGroup/assocActivity',
    '/document/*/assocActivityGroupList/assocActivityGroup/assocActivityType',
    '/document/*/assocActivityGroupList/assocActivityGroup/assocActivityNote',
    '/document/*/assocObjectGroupList/assocObjectGroup/assocObject',
    '/document/*/assocObjectGroupList/assocObjectGroup/assocObjectNote',
    '/document/*/assocObjectGroupList/assocObjectGroup/assocObjectType',
    '/document/*/assocConceptGroupList/assocConceptGroup/assocConceptNote',
    '/document/*/assocConceptGroupList/assocConceptGroup/assocConceptType',
    '/document/*/assocCulturalContextGroupList/assocCulturalContextGroup/assocCulturalContextNote',
    '/document/*/assocCulturalContextGroupList/assocCulturalContextGroup/assocCulturalContext',
    '/document/*/assocCulturalContextGroupList/assocCulturalContextGroup/assocCulturalContextType',
    '/document/*/assocOrganizationGroupList/assocOrganizationGroup/assocOrganizationType',
    '/document/*/assocOrganizationGroupList/assocOrganizationGroup/assocOrganizationNote',
    '/document/*/assocPersonGroupList/assocPersonGroup/assocPersonNote',
    '/document/*/assocPersonGroupList/assocPersonGroup/assocPersonType',
    '/document/*/assocPlaceGroupList/assocPlaceGroup/assocPlaceNote',
    '/document/*/assocPlaceGroupList/assocPlaceGroup/assocPlace',
    '/document/*/assocPlaceGroupList/assocPlaceGroup/assocPlaceType',
    '/document/*/assocEventName',
    '/document/*/assocEventNameType',
    '/document/*/assocEventPeoples/assocEventPeople',
    '/document/*/assocEventPlaces/assocEventPlace',
    '/document/*/assocEventNote',
    '/document/*/assocDateGroupList/assocDateGroup/assocStructuredDateGroup/dateDisplayDate',
    '/document/*/assocDateGroupList/assocDateGroup/assocDateNote',
    '/document/*/assocDateGroupList/assocDateGroup/assocDateType',
    '/document/*/objectHistoryNote',
    '/document/*/usageGroupList/usageGroup/usageNote',
    '/document/*/usageGroupList/usageGroup/usage',
    '/document/*/ownershipAccess',
    '/document/*/ownershipCategory',
    '/document/*/ownershipPlace',
    #'/document/*/ownershipDateGroupList/ownershipDateGroup',
    '/document/*/ownershipExchangeMethod',
    '/document/*/ownershipExchangeNote',
    '/document/*/ownershipExchangePriceValue',
    '/document/*/ownersPersonalExperience',
    '/document/*/ownersPersonalResponse',
    '/document/*/ownersReferences/ownersReference',
    '/document/*/ownersContributionNote',
    '/document/*/viewersRole',
    '/document/*/viewersPersonalExperience',
    '/document/*/viewersPersonalResponse',
    '/document/*/viewersReferences/viewersReference',
    '/document/*/viewersContributionNote',
    '/document/*/referenceGroupList/referenceGroup/referenceNote',
    #'/document/*/fieldCollectionDateGroup',
    '/document/*/fieldCollectionNumber',
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescription',
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionDateGroup/dateDisplayDate',
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionPosition',
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionType',
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionMethod',
    '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionInterpretation',

    ].each do |xpath|
      context "#{xpath}" do
        let(:doctext) { get_text(doc, xpath) }
          it 'is not empty' do
            verify_field_is_populated(doc, xpath)
          end
          
          it 'matches sample payload' do
            verify_value_match(doc, record, xpath)
          end
      end
    end
  end

  context 'Authority/vocab fields' do
    [
    { xpath: '/document/*/titleGroupList/titleGroup/titleLanguage',  transform: ->(text) { text.gsub!(/urn:.*?item:name\([^)]+\)'([^']+)'/, '\1') } },
    { xpath: '/document/*/titleGroupList/titleGroup/titleTranslationSubGroupList/titleTranslationSubGroup/titleTranslationLanguage',
    transform: ->(text) { text.gsub!(/urn:.*?item:name\([^)]+\)'([^']+)'/, '\1') } },
    { xpath: '/document/*/objectNameList/objectNameGroup[1]/objectNameLanguage', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectNameList/objectNameGroup[1]/objectNameLanguage', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/objectNameList/objectNameGroup[2]/objectNameLanguage', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectNameList/objectNameGroup[2]/objectNameLanguage', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/inventoryStatusList/inventoryStatus',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/publishToList/publishTo',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup[1]/objectProductionPerson',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup[1]/objectProductionPerson',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup[2]/objectProductionPerson',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup[2]/objectProductionPerson',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/contentPersons/contentPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/contentOrganizations/contentOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentInscriber', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup[1]/objectProductionOrganization',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup[1]/objectProductionOrganization',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup[2]/objectProductionOrganization',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup[2]/objectProductionOrganization',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/contentLanguages/contentLanguage[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/contentLanguages/contentLanguage[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/contentLanguages/contentLanguage[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/contentLanguages/contentLanguage[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/contentConcepts/contentConcept', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/ageQualifier', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentInscriber', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocConceptGroupList/assocConceptGroup[1]/assocConcept', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocConceptGroupList/assocConceptGroup[1]/assocConcept', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocConceptGroupList/assocConceptGroup[2]/assocConcept', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocConceptGroupList/assocConceptGroup[2]/assocConcept', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocOrganizationGroupList/assocOrganizationGroup[1]/assocOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocOrganizationGroupList/assocOrganizationGroup[1]/assocOrganization', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocOrganizationGroupList/assocOrganizationGroup[2]/assocOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocOrganizationGroupList/assocOrganizationGroup[2]/assocOrganization', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocPersonGroupList/assocPersonGroup[1]/assocPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocPersonGroupList/assocPersonGroup[1]/assocPerson', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocPersonGroupList/assocPersonGroup[2]/assocPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocPersonGroupList/assocPersonGroup[2]/assocPerson', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocEventOrganizations/assocEventOrganization[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocEventOrganizations/assocEventOrganization[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocEventOrganizations/assocEventOrganization[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocEventOrganizations/assocEventOrganization[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocEventPersons/assocEventPerson[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocEventPersons/assocEventPerson[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/assocEventPersons/assocEventPerson[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/assocEventPersons/assocEventPerson[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/owners/owner', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/ownershipExchangePriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/referenceGroupList/referenceGroup[1]/reference',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/referenceGroupList/referenceGroup[1]/reference',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/referenceGroupList/referenceGroup[2]/reference',  transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/referenceGroupList/referenceGroup[2]/reference',  transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/fieldCollectionMethods/fieldCollectionMethod', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionPlace', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup[1]/inscriptionDescriptionInscriber', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup[1]/inscriptionDescriptionInscriber', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup[2]/inscriptionDescriptionInscriber', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/nonTextualInscriptionGroupList/nonTextualInscriptionGroup[2]/inscriptionDescriptionInscriber', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    ].each do |xpath|
      context "#{xpath}" do
          let(:urn_vals) { urn_values(doc, xpath) }
          it 'is not empty' do
            verify_field_is_populated(doc, xpath)
          end

          it 'values are URNs' do
            verify_values_are_urns(urn_vals)
          end
          
          it 'URNs match sample payload' do
            verify_urn_match(urn_vals, record, xpath)
          end
        end
      end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'cataloging_core_excerpt.csv', 102) }
    let(:corecollectionobject) { CoreCollectionObject.new(attributes) }
    let(:doc) { Nokogiri::XML(corecollectionobject.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_collectionobject_row102.xml') }
      [
      '/document/*/objectNumber'
      ].each do |xpath|
          context "#{xpath}" do
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end
            
            it 'matches sample payload' do
              verify_value_match(doc, record, xpath)
            end
          end
        end
      end
  end

  context 'When fieldcollectionplace is tgn' do
    let(:attributes) { get_attributes_by_row('core', 'cataloging_core_excerpt.csv', 3) }
    let(:corecollectionobject) { CoreCollectionObject.new(attributes) }
    let(:doc) { Nokogiri::XML(corecollectionobject.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_collectionobject_row3.xml') }
      [
      { xpath: '/document/*/fieldCollectionPlace', transform: ->(text) { CSURN.parse(text)[:label] } },
      ].each do |xpath|
      context "#{xpath}" do
          let(:urn_vals) { urn_values(doc, xpath) }
          it 'is not empty' do
            verify_field_is_populated(doc, xpath)
          end

          it 'values are URNs' do
            verify_values_are_urns(urn_vals)
          end
          
          it 'URNs match sample payload' do
            verify_urn_match(urn_vals, record, xpath)
          end
        end
      end
  end
end
