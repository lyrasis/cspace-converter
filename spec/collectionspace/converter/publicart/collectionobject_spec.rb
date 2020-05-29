# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtCollectionObject do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'publicart.collectionspace.org'
  end

  let(:attributes) { get_attributes('publicart', 'collectionobject.csv') }
  let(:pacollectionobject) { PublicArtCollectionObject.new(attributes) }
  let(:doc) { get_doc(pacollectionobject) }
  let(:record) { get_fixture('publicart_collectionobject.xml') }

  describe '#map_common' do
    common = 'collectionobjects_common'
    context 'fields not included in publicart' do
      [
        "/document/#{common}/objectStatusList/objectStatus",
        "/document/#{common}/sex",
        "/document/#{common}/phase",
        "/document/#{common}/forms/form",
        "/document/#{common}/ageQualifier",
        "/document/#{common}/age",
        "/document/#{common}/ageUnit",
        "/document/#{common}/styles/style",
        "/document/#{common}/objectComponentGroupList/objectComponentGroup/objectComponentName",
        "/document/#{common}/objectComponentGroupList/objectComponentGroup/objectComponentInformation",
        "/document/#{common}/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentLanguage",
        "/document/#{common}/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentScript",
        "/document/#{common}/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentMethod",
        "/document/#{common}/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentInterpretation",
        "/document/#{common}/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentTranslation",
        "/document/#{common}/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentTransliteration",
        "/document/#{common}/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescription",
        "/document/#{common}/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionInscriber",
        "/document/#{common}/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionPosition",
        "/document/#{common}/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionType",
        "/document/#{common}/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionMethod",
        "/document/#{common}/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionInterpretation",
        "/document/#{common}/objectProductionReasons/objectProductionReason",
        "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup/objectProductionPeople",
        "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup/objectProductionPeopleRole",
        "/document/#{common}/assocActivityGroupList/assocActivityGroup/assocActivity",
        "/document/#{common}/assocActivityGroupList/assocActivityGroup/assocActivityType",
        "/document/#{common}/assocActivityGroupList/assocActivityGroup/assocActivityNote",
        "/document/#{common}/assocObjectGroupList/assocObjectGroup/assocObject",
        "/document/#{common}/assocObjectGroupList/assocObjectGroup/assocObjectType",
        "/document/#{common}/assocObjectGroupList/assocObjectGroup/assocObjectNote",
        "/document/#{common}/assocConceptGroupList/assocConceptGroup/assocConcept",
        "/document/#{common}/assocConceptGroupList/assocConceptGroup/assocConceptType",
        "/document/#{common}/assocConceptGroupList/assocConceptGroup/assocConceptNote",
        "/document/#{common}/assocCulturalContextGroupList/assocCulturalContextGroup/assocCulturalContext",
        "/document/#{common}/assocCulturalContextGroupList/assocCulturalContextGroup/assocCulturalContextType",
        "/document/#{common}/assocCulturalContextGroupList/assocCulturalContextGroup/assocCulturalContextNote",
        "/document/#{common}/assocOrganizationGroupList/assocOrganizationGroup/assocOrganization",
        "/document/#{common}/assocOrganizationGroupList/assocOrganizationGroup/assocOrganizationType",
        "/document/#{common}/assocOrganizationGroupList/assocOrganizationGroup/assocOrganizationNote",
        "/document/#{common}/assocPeopleGroupList/assocPeopleGroup/assocPeople",
        "/document/#{common}/assocPeopleGroupList/assocPeopleGroup/assocPeopleType",
        "/document/#{common}/assocPeopleGroupList/assocPeopleGroup/assocPeopleNote",
        "/document/#{common}/assocPersonGroupList/assocPersonGroup/assocPerson",
        "/document/#{common}/assocPersonGroupList/assocPersonGroup/assocPersonType",
        "/document/#{common}/assocPersonGroupList/assocPersonGroup/assocPersonNote",
        "/document/#{common}/assocPlaceGroupList/assocPlaceGroup/assocPlace",
        "/document/#{common}/assocPlaceGroupList/assocPlaceGroup/assocPlaceType",
        "/document/#{common}/assocPlaceGroupList/assocPlaceGroup/assocPlaceNote",
        "/document/#{common}/assocEventName",
        "/document/#{common}/assocEventNameType",
        "/document/#{common}/assocEventOrganizations/assocEventOrganization",
        "/document/#{common}/assocEventPeoples/assocEventPeople",
        "/document/#{common}/assocEventPersons/assocEventPerson",
        "/document/#{common}/assocEventPlaces/assocEventPlace",
        "/document/#{common}/assocEventNote",
        "/document/#{common}/assocDateGroupList/assocDateGroup/assocDateType",
        "/document/#{common}/assocDateGroupList/assocDateGroup/assocDateNote",
        "/document/#{common}/objectHistoryNote",
        "/document/#{common}/usageGroupList/usageGroup/usage",
        "/document/#{common}/usageGroupList/usageGroup/usageNote",
        "/document/#{common}/ownershipAccess",
        "/document/#{common}/ownershipCategory",
        "/document/#{common}/ownershipPlace",
        "/document/#{common}/ownershipExchangeMethod",
        "/document/#{common}/ownershipExchangeNote",
        "/document/#{common}/ownershipExchangePriceCurrency",
        "/document/#{common}/ownershipExchangePriceValue",
        "/document/#{common}/ownersPersonalExperience",
        "/document/#{common}/ownersPersonalResponse",
        "/document/#{common}/ownersReferences/ownersReference",
        "/document/#{common}/ownersContributionNote",
        "/document/#{common}/viewersRole",
        "/document/#{common}/viewersPersonalExperience",
        "/document/#{common}/viewersPersonalResponse",
        "/document/#{common}/viewersReferences/viewersReference",
        "/document/#{common}/viewersContributionNote",
        "/document/#{common}/fieldCollectionMethods/fieldCollectionMethod",
        "/document/#{common}/fieldCollectionPlace",
        "/document/#{common}/fieldCollectionSources/fieldCollectionSource",
        "/document/#{common}/fieldCollectors/fieldCollector",
        "/document/#{common}/fieldCollectionNumber",
        "/document/#{common}/fieldColEventNames/fieldColEventName",
        "/document/#{common}/fieldCollectionFeature",
        "/document/#{common}/fieldCollectionNote",
        "/document/#{common}/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentDateGroup/dateDisplayDate",
        "/document/#{common}/nonTextualInscriptionGroupList/nonTextualInscriptionGroup/inscriptionDescriptionDateGroup/dateDisplayDate",
        "/document/#{common}/assocDateGroupList/assocDateGroup/assocStructuredDateGroup/dateDisplayDate",
        "/document/#{common}/ownershipDateGroupList/ownershipDateGroup/dateDisplayDate",
        "/document/#{common}/fieldCollectionDateGroup/dateDisplayDate"
      ].each do |xpath|
        context xpath.to_s do
          it 'is empty' do
            verify_field_is_empty(doc, xpath)
          end
        end
      end
    end

    context 'authority/vocab fields' do
      [
        "/document/#{common}/responsibleDepartments/responsibleDepartment",
        "/document/#{common}/objectNameList/objectNameGroup/objectName",
        "/document/#{common}/materialGroupList/materialGroup/material",
        "/document/#{common}/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentInscriber",
        "/document/#{common}/objectProductionPersonGroupList/objectProductionPersonGroup/objectProductionPerson",
        "/document/#{common}/objectProductionOrganizationGroupList/objectProductionOrganizationGroup/objectProductionOrganization",
        "/document/#{common}/owners/owner"
      ].each do |xpath|
        context xpath.to_s do
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

  describe '#map_publicart' do
    pa = 'collectionobjects_publicart'
    context 'authority/vocab fields' do
      [
        "/document/#{pa}/publicartCollections/publicartCollection",
        "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup/publicartProductionPerson",
        "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup/publicartProductionPersonRole",
        "/document/#{pa}/publicartProductionDateGroupList/publicartProductionDateGroup/publicartProductionDateType"
      ].each do |xpath|
        context xpath.to_s do
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

    context 'structured date fields' do
      [
        "/document/#{pa}/publicartProductionDateGroupList/publicartProductionDateGroup/publicartProductionDate"
      ].each do |xpath|
        context xpath.to_s do
          it 'is not empty' do
            expect(doc.xpath(xpath).size).to_not eq(0)
          end

          it 'matches sample payload' do
            expect(get_structured_date(doc, xpath)).to eq(get_structured_date(record, xpath))
          end
        end
      end
    end

    context 'non-authority/vocab fields' do
      [
        "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup/publicartProductionPersonType"
      ].each do |xpath|
        context xpath.to_s do
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
end
