require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreLocation do
  let(:attributes) { get_attributes('core', 'location_core_all.csv') }
  let(:corelocation) { CoreLocation.new(attributes) }
  let(:doc) { Nokogiri::XML(corelocation.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_location.xml') }
  let(:xpaths) {[
    "/document/*/locTermGroupList/locTermGroup/termDisplayName",
    { xpath: "/document/*/locTermGroupList/locTermGroup/termLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/locTermGroupList/locTermGroup/termPrefForLang",
    "/document/*/locTermGroupList/locTermGroup/termType",
    "/document/*/locTermGroupList/locTermGroup/termQualifier",
    { xpath: "/document/*/locTermGroupList/locTermGroup/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/locTermGroupList/locTermGroup/termSourceID",
    "/document/*/locTermGroupList/locTermGroup/termSourceDetail",
    "/document/*/locTermGroupList/locTermGroup/termSourceNote",
    "/document/*/locTermGroupList/locTermGroup/termStatus",
    "/document/*/locTermGroupList/locTermGroup/termName",
    "/document/*/locTermGroupList/locTermGroup/termFormattedDisplayName",
    "/document/*/locationType",
    "/document/*/accessNote",
    "/document/*/address",
    "/document/*/conditionGroupList/conditionGroup/conditionNote",
    "/document/*/conditionGroupList/conditionGroup/conditionNoteDate",
    "/document/*/securityNote"
  ]}
  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'location_core_all.csv', 7) }
    let(:doc) { Nokogiri::XML(corelocation.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_location_row7.xml') }
    let(:xpath_required) {[
      "/document/*/locTermGroupList/locTermGroup/termDisplayName"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
