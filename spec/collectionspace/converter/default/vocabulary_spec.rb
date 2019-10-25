require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Default::Vocabulary do
  let(:attributes) { get_attributes('default', 'vocabulary.csv') }
  let(:vocabulary) { Lookup.default_vocabulary_class.new(attributes) }
  let(:doc) { Nokogiri::XML(vocabulary.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('vocabulary.xml') }
  let(:xpaths) {[
    '/document/*/displayName',
    '/document/*/shortIdentifier',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
