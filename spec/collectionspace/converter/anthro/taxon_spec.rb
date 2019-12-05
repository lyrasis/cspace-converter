require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Anthro::AnthroTaxon do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'anthro.collectionspace.org'
  end

  let(:attributes) { get_attributes('anthro', 'anthro_taxon_all.csv') }
  let(:anthrotaxon) { AnthroTaxon.new(attributes) }
  let(:doc) { get_doc(anthrotaxon) }
  let(:record) { get_fixture('anthro_taxonomy.xml') }
  let(:p) { 'taxon_common' }
  let(:xpaths) {[
    "/document/#{p}/commonNameGroupList/commonNameGroup/commonName",
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termDisplayName",
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termFlag",
    { xpath: "/document/#{p}/taxonTermGroupList/taxonTermGroup/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termStatus",
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
