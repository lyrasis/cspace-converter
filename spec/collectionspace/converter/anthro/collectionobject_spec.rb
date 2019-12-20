require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Anthro::AnthroCollectionObject do
    after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'anthro.collectionspace.org'
  end

  let(:common) { 'collectionobjects_common' }
  let(:anthro) { 'collectionobjects_anthro' }

  context 'sample data row 2' do
  let(:attributes) { get_attributes('anthro', 'collectionobject_partial.csv') }
  let(:anthrocollectionobject) { AnthroCollectionObject.new(attributes) }
  let(:doc) { get_doc(anthrocollectionobject) }
  let(:record) { get_fixture('anthro_collectionobject_2.xml') }
  let(:xpaths) {[
    { xpath: "/document/#{anthro}/localityGroupList/localityGroup/fieldLocPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
    "/document/#{anthro}/localityGroupList/localityGroup/fieldLocCounty",
    "/document/#{anthro}/localityGroupList/localityGroup/fieldLocState",
    "/document/#{anthro}/localityGroupList/localityGroup/localityNote",
#    "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/ageRange",
#    { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/ageRange", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
    { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/ageRange", transform: ->(text) { text.gsub!(/urn:.*?item:name\([^)]+\)'([^']+)'/, '\1').downcase } },
    { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/behrensmeyerUpper", transform: ->(text) { text.gsub!(/urn:.*?item:name\([^)]+\)'([^']+)'/, '\1') } },
    { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/behrensmeyerSingleLower", transform: ->(text) { text.gsub!(/urn:.*?item:name\([^)]+\)'([^']+)'/, '\1') } },
    "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/commingledRemainsNote",
    "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/sex",
    "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/count",
    "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/minIndividuals",
    "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/dentition",
    "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/bone",
    "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/mortuaryTreatmentGroupList/mortuaryTreatment/mortuaryTreatment",
    "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/mortuaryTreatmentGroupList/mortuaryTreatment/mortuaryTreatmentNote"
  ]}

  xit "Maps attributes correctly" do
    puts doc
    test_converter(doc, record, xpaths)
  end
  end #  context 'sample data row 2'
end
