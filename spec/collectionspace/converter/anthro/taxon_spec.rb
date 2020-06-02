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
    { xpath: "/document/#{p}/commonNameGroupList/commonNameGroup[1]/commonNameLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{p}/commonNameGroupList/commonNameGroup[2]/commonNameLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/#{p}/commonNameGroupList/commonNameGroup/commonNameSourceDetail",
    { xpath: "/document/#{p}/commonNameGroupList/commonNameGroup[1]/commonNameSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/commonNameGroupList/commonNameGroup[2]/commonNameSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termSourceID",
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termSourceDetail",
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termSourceNote",
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termFormattedDisplayName",
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termType",
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/taxonomicStatus",
    { xpath: "/document/#{p}/taxonTermGroupList/taxonTermGroup/termLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termQualifier",
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termPrefForLang",
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termDisplayName",
    { xpath: "/document/#{p}/taxonTermGroupList/taxonTermGroup/termFlag", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{p}/taxonTermGroupList/taxonTermGroup/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/taxonTermGroupList/taxonTermGroup/termStatus",
    "/document/#{p}/taxonRank",
    "/document/#{p}/taxonCurrency",
    { xpath: "/document/#{p}/taxonAuthorGroupList/taxonAuthorGroup[1]/taxonAuthor", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/taxonAuthorGroupList/taxonAuthorGroup[2]/taxonAuthor", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/taxonAuthorGroupList/taxonAuthorGroup/taxonAuthorType",
    "/document/#{p}/taxonYear",
    { xpath: "/document/#{p}/taxonCitationList/taxonCitation[1]", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/taxonCitationList/taxonCitation[2]", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/taxonIsNamedHybrid",
    "/document/#{p}/taxonNote"
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('anthro', 'anthro_taxon_all.csv', 12) }
    let(:doc) { get_doc(anthrotaxon) }
    let(:record) { get_fixture('anthro_taxonomy_row12.xml') }
    let(:p) { 'taxon_common' }
    let(:xpath_required) {[
      "/document/#{p}/taxonTermGroupList/taxonTermGroup/termDisplayName",
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
