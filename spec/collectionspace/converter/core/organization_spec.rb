require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreOrganization do
  let(:attributes) { get_attributes('core', 'authorg_core_all.csv') }
  let(:coreorganization) { CoreOrganization.new(Lookup.profile_defaults('organization').merge(attributes)) }
  let(:doc) { get_doc(coreorganization) }
  let(:record) { get_fixture('core_organization.xml') }
  let(:xpaths) {[
    "/document/*/orgTermGroupList/orgTermGroup/termDisplayName",
    "/document/*/orgTermGroupList/orgTermGroup/mainBodyName",
    "/document/*/orgTermGroupList/orgTermGroup/termName",
    "/document/*/orgTermGroupList/orgTermGroup/additionsToName",
    { xpath: "/document/*/orgTermGroupList/orgTermGroup/termLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/orgTermGroupList/orgTermGroup/termPrefForLang",
    "/document/*/orgTermGroupList/orgTermGroup/termType",
    "/document/*/orgTermGroupList/orgTermGroup/termQualifier",
    { xpath: "/document/*/orgTermGroupList/orgTermGroup/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/orgTermGroupList/orgTermGroup/termSourceID",
    "/document/*/orgTermGroupList/orgTermGroup/termSourceDetail",
    "/document/*/orgTermGroupList/orgTermGroup/termSourceNote",
    "/document/*/orgTermGroupList/orgTermGroup/termStatus",
    { xpath: "/document/*/orgTermGroupList/orgTermGroup/termFlag", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/dissolutionDateGroup/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/*/foundingDateGroup/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    "/document/*/foundingPlace",
    { xpath: "/document/*/contactGroupList/contactGroup/contactEndDateGroup/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/*/contactGroupList/contactGroup/contactDateGroup/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/*/contactGroupList/contactGroup/contactStatus", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/contactGroupList/contactGroup/contactName", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/contactGroupList/contactGroup/contactRole", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/organizationRecordTypes/organizationRecordType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/groups/group",
    "/document/*/functions/function",
    "/document/*/historyNotes/historyNote",
    "/document/*/emailGroupList/emailGroup/email",
    "/document/*/emailGroupList/emailGroup/emailType",
    "/document/*/telephoneNumberGroupList/telephoneNumberGroup/telephoneNumber",
    "/document/*/telephoneNumberGroupList/telephoneNumberGroup/telephoneNumberType",
    "/document/*/faxNumberGroupList/faxNumberGroup/faxNumber",
    "/document/*/faxNumberGroupList/faxNumberGroup/faxNumberType",
    "/document/*/webAddressGroupList/webAddressGroup/webAddress",
    "/document/*/webAddressGroupList/webAddressGroup/webAddressType",
    "/document/*/addressGroupList/addressGroup/addressType",
    "/document/*/addressGroupList/addressGroup/addressPlace1",
    "/document/*/addressGroupList/addressGroup/addressPlace2",
    "/document/*/addressGroupList/addressGroup/addressMunicipality",
    "/document/*/addressGroupList/addressGroup/addressStateOrProvince",
    "/document/*/addressGroupList/addressGroup/addressPostCode",
    "/document/*/addressGroupList/addressGroup/addressCountry",
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'authorg_core_all.csv', 15) }
    let(:doc) { get_doc(coreorganization) }
    let(:record) { get_fixture('core_organization_row15.xml') }
    let(:xpath_required) {[
      "/document/*/orgTermGroupList/orgTermGroup/termDisplayName"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
