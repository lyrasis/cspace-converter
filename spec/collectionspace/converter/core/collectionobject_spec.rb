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
    { xpath: '/document/*/titleGroupList/titleGroup/titleLanguage', transform: ->(text) { CSURN.parse(text)[:label] } },
    # '/document/*/collection', # static list
    '/document/*/objectNameList/objectNameGroup/objectName',
    '/document/*/briefDescriptions/briefDescription',
    # '/document/*/responsibleDepartments/responsibleDepartment', # static list
    # '/document/*/recordStatus', # static list
    '/document/*/comments/comment',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSummary',
    # '/document/*/copyNumber', # TODO add data
    # '/document/*/editionNumber', # TODO add data
    # '/document/*/forms/form', # TODO add data
    '/document/*/materialGroupList/materialGroup/material',
    # '/document/*/objectStatusList/objectStatus', # TODO add data
    # '/document/*/phase', # TODO add data
    # '/document/*/sex', # TODO add data
    # '/document/*/styles/style', # TODO add data
    # '/document/*/technicalAttributeGroupList/...', # TODO add data
    # '/document/*/objectComponentGroupList/...', # TODO add data
    '/document/*/objectProductionDateGroupList/objectProductionDateGroup/dateEarliestScalarValue',
    '/document/*/objectProductionDateGroupList/objectProductionDateGroup/dateLatestScalarValue',
    # '/document/*/objectProductionOrganization/...', # TODO add data
    # '/document/*/objectProductionPeopleGroupList/...', # TODO add data
    '/document/*/objectProductionPlaceGroupList/objectProductionPlaceGroup/objectProductionPlace',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
