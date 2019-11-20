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

  it "Maps core concept attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end

RSpec.describe CollectionSpace::Converter::Core::CoreConcept do
  let(:attributes) { get_attributes('core', 'authconcept_nomenclature_terms.csv') }
  let(:coreconcept) { CoreConcept.new(Lookup.profile_defaults('nomenclature').merge(attributes)) }
  let(:doc) { Nokogiri::XML(coreconcept.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_concept_nomenclature.xml') }
  let(:xpaths) {[
    '/document/*/conceptRecordTypes/conceptRecordType',
    '/document/*/conceptTermGroupList/conceptTermGroup/historicalStatus',
    '/document/*/conceptTermGroupList/conceptTermGroup/termDisplayName',
    '/document/*/conceptTermGroupList/conceptTermGroup/termLanguage',
    '/document/*/conceptTermGroupList/conceptTermGroup/termPrefForLang',
#    '/document/*/conceptTermGroupList/conceptTermGroup/termSource',
    '/document/*/conceptTermGroupList/conceptTermGroup/termSourceID',
    '/document/*/conceptTermGroupList/conceptTermGroup/termSourceNote',
    '/document/*/conceptTermGroupList/conceptTermGroup/termStatus',
    '/document/*/conceptTermGroupList/conceptTermGroup/termType',
    '/document/*/scopeNote'
  ]}

  it "Maps core concept AND nomenclature default attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
