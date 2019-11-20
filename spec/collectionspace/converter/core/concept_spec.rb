require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreConcept do
  let(:attributes) { get_attributes('core', 'authconcept_nomenclature_terms.csv') }
  let(:coreconcept) { CoreConcept.new(attributes) }
  let(:doc) { Nokogiri::XML(coreconcept.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_concept.xml') }
  let(:xpaths) {[
    '/document/*/conceptRecordTypes/conceptRecordType',
    '/document/*/conceptTermGroupList/conceptTermGroup/termSourceID',
    '/document/*/conceptTermGroupList/conceptTermGroup/termSourceNote',
    '/document/*/conceptTermGroupList/conceptTermGroup/termDisplayName',
    '/document/*/scopeNote'
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
