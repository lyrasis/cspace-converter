require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Materials::MaterialsCollectionObject do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'materials.collectionspace.org'
  end

  let(:attributes) { get_attributes('materials', 'cataloging_materials_all.csv') }
  let(:materialscollectionobject) { MaterialsCollectionObject.new(attributes) }
  let(:doc) { get_doc(materialscollectionobject) }
  let(:record) { get_fixture('materials_collectionobject.xml') }
  let(:p) { 'collectionobjects_common' }
  let(:ext) { 'collectionobjects_materials' }
  let(:xpaths) {[
    "/document/#{ext}/materialPhysicalDescriptions/materialPhysicalDescription",
    "/document/#{ext}/materialConditionGroupList/materialConditionGroup/conditionNote",
    "/document/#{ext}/materialContainerGroupList/materialContainerGroup/containerNote",
    "/document/#{ext}/materialHandlingGroupList/materialHandlingGroup/handlingNote",
    "/document/#{ext}/materialFinishGroupList/materialFinishGroup/finishNote",
    { xpath: "/document/#{ext}/materialConditionGroupList/materialConditionGroup/condition", transform: ->(text) { CSURN.parse(text)[:label].downcase }},
    { xpath: "/document/#{ext}/materialContainerGroupList/materialContainerGroup/container", transform: ->(text) { CSURN.parse(text)[:label].downcase }},
    { xpath: "/document/#{ext}/materialHandlingGroupList/materialHandlingGroup/handling", transform: ->(text) { CSURN.parse(text)[:label].downcase }},
    { xpath: "/document/#{ext}/materialFinishGroupList/materialFinishGroup/finish", transform: ->(text) { CSURN.parse(text)[:label].downcase }},
    { xpath: "/document/#{ext}/materialGenericColors/materialGenericColor", transform: ->(text) { CSURN.parse(text)[:label].downcase }},
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
