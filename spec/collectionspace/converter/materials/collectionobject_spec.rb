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
    # "/document/#{ext}/materialHandlingGroupList/materialHandlingGroup/handlingNote"
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
