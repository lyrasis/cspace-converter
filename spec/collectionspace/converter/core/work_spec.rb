require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreWork do
  let(:attributes) { get_attributes('core', 'authwork_core_all.csv') }
  let(:corework) { CoreWork.new(Lookup.profile_defaults('work').merge(attributes)) }
  let(:doc) { get_doc(corework) }
  let(:record) { get_fixture('core_work.xml') }
  let(:xpaths) {[
    "/document/*/workTermGroupList/workTermGroup/termDisplayName",
    "/document/*/workTermGroupList/workTermGroup/termName",
    { xpath: "/document/*/workTermGroupList/workTermGroup/termLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/workTermGroupList/workTermGroup/termPrefForLang",
    "/document/*/workTermGroupList/workTermGroup/termType",
    "/document/*/workTermGroupList/workTermGroup/termQualifier",
    { xpath: "/document/*/workTermGroupList/workTermGroup/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/workTermGroupList/workTermGroup/termSourceID",
    "/document/*/workTermGroupList/workTermGroup/termSourceDetail",
    "/document/*/workTermGroupList/workTermGroup/termSourceNote",
    "/document/*/workTermGroupList/workTermGroup/termStatus",
    { xpath: "/document/*/workTermGroupList/workTermGroup/termFlag", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/workDateGroupList/workDateGroup[1]/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/*/workDateGroupList/workDateGroup[2]/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/*/workType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/workHistoryNote",
    { xpath: "/document/*/creatorGroupList/creatorGroup[1]/creatorType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/creatorGroupList/creatorGroup[2]/creatorType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/creatorGroupList/creatorGroup[1]/creator", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/creatorGroupList/creatorGroup[2]/creator", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/publisherGroupList/publisherGroup[1]/publisher", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/publisherGroupList/publisherGroup[2]/publisher", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/publisherGroupList/publisherGroup[1]/publisherType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/publisherGroupList/publisherGroup[2]/publisherType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/addrGroupList/addrGroup/addressPlace1",
    "/document/*/addrGroupList/addrGroup/addressPlace2",
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressMunicipality", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressMunicipality", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressStateOrProvince", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressStateOrProvince", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/addrGroupList/addrGroup/addressPostCode",
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressCountry", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressCountry", transform: ->(text) { CSURN.parse(text)[:label] } },
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'authwork_core_all.csv', 12) }
    let(:doc) { get_doc(corework) }
    let(:record) { get_fixture('core_work_row12.xml') }
    let(:xpath_required) {[
      "/document/*/workTermGroupList/workTermGroup/termDisplayName"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
