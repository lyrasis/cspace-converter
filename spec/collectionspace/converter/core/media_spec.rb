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
    # '/document/*/dateGroupList/dateGroup/dateDisplayDate',
    '/document/*/dateGroupList/dateGroup/dateLatestScalarValue',
    '/document/*/description',
    '/document/*/externalUrl',
    '/document/*/identificationNumber',
    { xpath: '/document/*/languageList/language', transform: ->(text) { CSURN.parse(text)[:label].downcase } }
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSummary',
    '/document/*/measuredPartGroupList/measuredPartGroup/measuredPart',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/dimension',
    {
      xpath: '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measuredBy',
      transform: ->(text) { CSURN.parse(text)[:label] }
    },
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measurementMethod',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measurementUnit',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/value',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/valueDate',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/valueQualifier',
    { xpath: '/document/*/publisher', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/rightsHolder', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/source',
    '/document/*/subjectList/subject',
    '/document/*/title',
    '/document/*/typeList/type',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
