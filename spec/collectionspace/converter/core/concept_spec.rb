require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreConcept do
  let(:attributes) { get_attributes('core', 'authconcept_nomenclature_terms.csv') }
  let(:coreconcept) { CoreConcept.new(attributes, config: {identifier: 'termDisplayName'} ) }
  #let(:coreconcept) { CoreConcept.new(Lookup.profile_defaults('nomenclature').merge(attributes)) }
  let(:doc) { Nokogiri::XML(coreconcept.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_concept_nomenclature_full.xml') }
  let(:xpaths) {[
    { xpath: '/document/*/conceptRecordTypes/conceptRecordType[1]',
     transform: ->(text) {CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/conceptRecordTypes/conceptRecordType[2]',
     transform: ->(text) {CSURN.parse(text)[:label].downcase } },
    '/document/*/conceptTermGroupList/conceptTermGroup/termDisplayName',
    '/document/*/conceptTermGroupList/conceptTermGroup/termName',
    '/document/*/conceptTermGroupList/conceptTermGroup/termQualifier',
    '/document/*/conceptTermGroupList/conceptTermGroup/termStatus',
    '/document/*/conceptTermGroupList/conceptTermGroup/termType',
    { xpath: '/document/*/conceptTermGroupList/conceptTermGroup[2]/termFlag',
     transform: ->(text) {CSURN.parse(text)[:label].downcase } }, 
    { xpath: '/document/*/conceptTermGroupList/conceptTermGroup[3]/termFlag',
     transform: ->(text) {CSURN.parse(text)[:label].downcase } }, 
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
    '/document/*/scopeNote',
    '/document/*/scopeNoteSource',
    '/document/*/scopeNoteSourceDetail',
    '/document/*/citationGroupList/citationGroup/citationSource',
    '/document/*/citationGroupList/citationGroup/citationSourceDetail',
    '/document/*/additionalSourceGroupList/additionalSourceGroup/additionalSource',
    '/document/*/additionalSourceGroupList/additionalSourceGroup/additionalSourceNote',
    '/document/*/additionalSourceGroupList/additionalSourceGroup/additionalSourceDetail',
    '/document/*/additionalSourceGroupList/additionalSourceGroup/additionalSourceID',
    '/document/*/shortIdentifier']}

  it "Maps core concept attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end



