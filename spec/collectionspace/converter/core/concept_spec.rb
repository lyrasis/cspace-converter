require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreConcept do
  let(:attributes) { get_attributes('core', 'authconcept_nomenclature_terms.csv') }
  let(:coreconcept) { CoreConcept.new(attributes) }
  let(:doc) { Nokogiri::XML(coreconcept.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_concept_nomenclature_full.xml') }
  let(:xpaths) {[
    '/document/*/conceptRecordTypes/conceptRecordType',
    '/document/*/conceptTermGroupList/conceptTermGroup/termDisplayName',
    '/document/*/conceptTermGroupList/conceptTermGroup/termName',
    '/document/*/conceptTermGroupList/conceptTermGroup/termQualifier',
    '/document/*/conceptTermGroupList/conceptTermGroup/termStatus',
    '/document/*/conceptTermGroupList/conceptTermGroup/termType',
    '/document/*/conceptTermGroupList/conceptTermGroup/termFlag',    
    '/document/*/conceptTermGroupList/conceptTermGroup/historicalStatus',
    { xpath: '/document/*/conceptTermGroupList/conceptTermGroup[1]/termLanguage',
     transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/conceptTermGroupList/conceptTermGroup[2]/termLanguage',
     transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/conceptTermGroupList/conceptTermGroup[3]/termLanguage',
     transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    '/document/*/conceptTermGroupList/conceptTermGroup/termPrefForLang',
    { xpath: '/document/*/conceptTermGroupList/conceptTermGroup[1]/termSource',
     transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/conceptTermGroupList/conceptTermGroup[2]/termSource',
     transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/conceptTermGroupList/conceptTermGroup[3]/termSource',
     transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    '/document/*/conceptTermGroupList/conceptTermGroup/termSourceDetail',
    '/document/*/conceptTermGroupList/conceptTermGroup/termSourceID',
    '/document/*/conceptTermGroupList/conceptTermGroup/termSourceNote',
    '/document/*/scopeNote'
  ]}

  it "Maps core concept attributes correctly" do
    test_converter(doc, record, xpaths)
#    puts "\n\nCORE CONCEPT:"
#    puts doc
  end
end



