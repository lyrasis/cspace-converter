require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Materials::MaterialsCollectionObject do
  let(:attributes) { get_attributes('materials', 'cataloging_materials_all.csv') }
  let(:materialscollectionobject) { MaterialsCollectionObject.new(attributes) }
  let(:doc) { get_doc(materialscollectionobject) }
  let(:record) { get_fixture('materials_collectionobject.xml') }
  let(:p) { 'collectionobjects_common' }
  let(:ext) { 'collectionobjects_materials' }
  let(:xpaths) {[
    "/document/#{p}/objectNumber",
    "/document/#{p}/otherNumberList/otherNumber/numberType",
    "/document/#{p}/otherNumberList/otherNumber/numberValue",
    "/document/#{p}/briefDescriptions/briefDescription",
    "/document/#{ext}/materialConditionGroupList/materialConditionGroup/conditionNote",
    { xpath: "/document/#{ext}/materialConditionGroupList/materialConditionGroup/condition", transform: ->(text) { CSURN.parse(text)[:label].downcase }},  
    "/document/#{ext}/materialContainerGroupList/materialContainerGroup/containerNote",
    { xpath: "/document/#{ext}/materialContainerGroupList/materialContainerGroup/container", transform: ->(text) { CSURN.parse(text)[:label].downcase }},
    "/document/#{ext}/materialHandlingGroupList/materialHandlingGroup/handlingNote",
    { xpath: "/document/#{ext}/materialHandlingGroupList/materialHandlingGroup/handling", transform: ->(text) { CSURN.parse(text)[:label].downcase }},
    "/document/#{p}/inventoryStatusList/inventoryStatus",
    "/document/#{p}/materialGroupList/material",
    "/document/#{p}/numberOfObjects", 
    "/document/#{p}/publishToList/publishTo",
    "/document/#{p}/collection",
    "/document/#{p}/recordStatus",
    "/document/#{p}/colors/color",
    "/document/#{p}/measuredPartGroupList/measuredPartGroup/dimensionSummary",
    "/document/#{p}/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/dimension",
    "/document/#{p}/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/value",
    "/document/#{p}/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measurementUnit",
    "/document/#{ext}/materialFinishGroupList/materialFinishGroup/finishNote",
    { xpath: "/document/#{ext}/materialFinishGroupList/materialFinishGroup/finish", transform: ->(text) { CSURN.parse(text)[:label].downcase }},
    { xpath: "/document/#{ext}/materialGenericColors/materialGenericColor", transform: ->(text) { CSURN.parse(text)[:label].downcase }},
    "/document/#{p}/objectStatusList/objectStatus",
    "/document/#{ext}/materialPhysicalDescriptions/materialPhysicalDescription",
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
