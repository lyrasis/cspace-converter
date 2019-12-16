require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreCollectionObject do
  let(:attributes) { get_attributes('core', 'cataloging_core_excerpt.csv') }
  let(:corecollectionobject) { CoreCollectionObject.new(attributes) }
  let(:doc) { Nokogiri::XML(corecollectionobject.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_collectionobject.xml') }
  let(:xpaths) {[
    '/document/*/objectNumber',
    '/document/*/numberOfObjects',
    '/document/*/titleGroupList/titleGroup/title',
    { xpath: '/document/*/titleGroupList/titleGroup/titleLanguage',  transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/titleGroupList/titleGroup/titleTranslationSubGroupList/titleTranslationSubGroup/titleTranslation',
    { xpath: '/document/*/titleGroupList/titleGroup/titleTranslationSubGroupList/titleTranslationSubGroup/titleTranslationLanguage',
    transform: ->(text) { text.gsub!(/urn:.*?item:name\([^)]+\)'([^']+)'/, '\1') } },
#    '/document/*/titleGroupList/titleGroup/titleTranslationSubGroupList/titleTranslationSubGroup/titleTranslationLanguage',
    '/document/*/collection',
    '/document/*/objectNameList/objectNameGroup/objectName',
    '/document/*/briefDescriptions/briefDescription',
    '/document/*/responsibleDepartments/responsibleDepartment',
    '/document/*/recordStatus',
    '/document/*/comments/comment',
    '/document/*/fieldColEventNames/fieldColEventName',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSummary',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/dimension',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/value',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measurementUnit',
    '/document/*/measuredPartGroupList/measuredPartGroup/measuredPart',
    '/document/*/copyNumber',
    '/document/*/editionNumber',
    '/document/*/forms/form',
    '/document/*/materialGroupList/materialGroup/material',
    '/document/*/objectStatusList/objectStatus',
    # '/document/*/otherNumberList/otherNumber/numberValue',
    # '/document/*/otherNumberList/otherNumber/numberType',
    # { xpath: '/document/*/inventoryStatusList/inventoryStatus',  transform: ->(text) { CSURN.parse(text)[:label] } },
    # { xpath: '/document/*/publishToList/publishTo',  transform: ->(text) { CSURN.parse(text)[:label] } },
    # '/document/*/assocPeopleGroupList/assocPeopleGroup/assocPeople',
    # '/document/*/assocPeopleGroupList/assocPeopleGroup/assocPeopleType',
    '/document/*/phase',
    '/document/*/sex',
    # '/document/*/objectProductionNote',
    # '/document/*/fieldCollectionNote',
    # '/document/*/fieldCollectionFeature',
    '/document/*/styles/style',
    '/document/*/technicalAttributeGroupList/technicalAttributeGroup/technicalAttribute',
    '/document/*/objectComponentGroupList/objectComponentGroup/objectComponentName',
    '/document/*/objectProductionDateGroupList/objectProductionDateGroup/dateEarliestScalarValue',
    '/document/*/objectProductionDateGroupList/objectProductionDateGroup/dateLatestScalarValue',
    { xpath: '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup/objectProductionPerson',  transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/objectProductionPersonGroupList/objectProductionPersonGroup/objectProductionPersonRole',
    { xpath: '/document/*/contentPersons/contentPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentInscriber', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/textualInscriptionGroupList/textualInscriptionGroup/inscriptionContentMethod',
    { xpath: '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup/objectProductionOrganization',  transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/objectProductionOrganizationGroupList/objectProductionOrganizationGroup/objectProductionOrganizationRole',
    '/document/*/techniqueGroupList/techniqueGroup/technique',
    '/document/*/objectProductionPeopleGroupList/objectProductionPeopleGroup/objectProductionPeople',
    # '/document/*/objectProductionPeopleGroupList/objectProductionPeopleGroup/objectProductionPeopleRole',
    '/document/*/objectProductionPlaceGroupList/objectProductionPlaceGroup/objectProductionPlace',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
