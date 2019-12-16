require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Anthro::AnthroCollectionObject do
  let(:attributes) { get_attributes('anthro', 'collectionobject_partial.csv') }
  let(:anthrocollectionobject) { AnthroCollectionObject.new(attributes) }
  let(:doc) { Nokogiri::XML(anthrocollectionobject.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('anthro_collectionobject.xml') }
  let(:xpaths) {[
  ]}

  it "Maps attributes correctly" do
    puts doc
    test_converter(doc, record, xpaths)
  end
end
