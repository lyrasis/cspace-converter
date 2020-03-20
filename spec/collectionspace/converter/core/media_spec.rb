require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreMedia do
  let(:attributes) { get_attributes('core', 'mediahandling_core_all.csv') }
  let(:coremedia) { CoreMedia.new(attributes) }
  let(:doc) { Nokogiri::XML(coremedia.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_media.xml') }
  let(:xpaths) {[
    { xpath: '/document/*/contributor', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/copyrightStatement',
    '/document/*/coverage',
    { xpath: '/document/*/creator', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/dateGroupList/dateGroup/dateDisplayDate',
    '/document/*/description',
    '/document/*/externalUrl',
    '/document/*/identificationNumber',
    { xpath: '/document/*/languageList/language[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/languageList/language[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/languageList/language[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/languageList/language[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
=begin
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSummary',
    '/document/*/measuredPartGroupList/measuredPartGroup/measuredPart',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/dimension',
    {
      xpath: '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup[1]/measuredBy',
      transform: ->(text) { CSURN.parse(text)[:label] }
    },
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measurementMethod',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measurementUnit',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/value',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/valueDate',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/valueQualifier',
=end
    { xpath: '/document/*/publisher', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/rightsHolder', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/source',
    '/document/*/subjectList/subject',
    '/document/*/title',
    '/document/*/typeList/type',
    '/document/*/relationList/relation'
  ]}
 
  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'mediahandling_core_all.csv', 11) }
    let(:doc) { Nokogiri::XML(coremedia.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_media_row11.xml') }
    let(:xpath_required) {[
      '/document/*/identificationNumber'
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end 
