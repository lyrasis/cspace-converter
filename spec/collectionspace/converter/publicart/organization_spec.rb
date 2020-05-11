require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtOrganization do
  let(:attributes) { get_attributes('publicart', 'Org_auth_publicart.csv') }
  let(:publicartorganization) { PublicArtOrganization.new(Lookup.profile_defaults('organization').merge(attributes)) }
  let(:doc) { get_doc(publicartorganization) }
  let(:record) { get_fixture('publicart_organization.xml') } 
  let(:p) { 'organizations_common' }
  let(:ext) { 'organizations_publicart' }
  let(:c) { 'contacts_common' }
  let(:xpaths) {[
    "/document/#{p}/orgTermGroupList/orgTermGroup/termDisplayName",
    "/document/#{p}/orgTermGroupList/orgTermGroup/mainBodyName",
    "/document/#{p}/orgTermGroupList/orgTermGroup/termName",
    "/document/#{p}/orgTermGroupList/orgTermGroup/additionsToName",
    { xpath: "/document/#{p}/orgTermGroupList/orgTermGroup/termLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/#{p}/orgTermGroupList/orgTermGroup/termPrefForLang",
    "/document/#{p}/orgTermGroupList/orgTermGroup/termType",
    "/document/#{p}/orgTermGroupList/orgTermGroup/termQualifier",
    { xpath: "/document/#{p}/orgTermGroupList/orgTermGroup/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/orgTermGroupList/orgTermGroup/termSourceID",
    "/document/#{p}/orgTermGroupList/orgTermGroup/termSourceDetail",
    "/document/#{p}/orgTermGroupList/orgTermGroup/termSourceNote",
    "/document/#{p}/orgTermGroupList/orgTermGroup/termStatus",
    { xpath: "/document/#{p}/orgTermGroupList/orgTermGroup/termFlag", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{p}/dissolutionDateGroup/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/#{p}/foundingDateGroup/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/#{p}/foundingPlace", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/organizationRecordTypes/organizationRecordType[1]", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{p}/organizationRecordTypes/organizationRecordType[1]", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/#{p}/organizationRecordTypes/organizationRecordType[2]", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{p}/organizationRecordTypes/organizationRecordType[2]", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    "/document/#{p}/historyNotes/historyNote",
    "/document/#{c}/emailGroupList/emailGroup/email",
    "/document/#{c}/emailGroupList/emailGroup/emailType",
    "/document/#{c}/telephoneNumberGroupList/telephoneNumberGroup/telephoneNumber",
    "/document/#{c}/telephoneNumberGroupList/telephoneNumberGroup/telephoneNumberType",
    "/document/#{c}/faxNumberGroupList/faxNumberGroup/faxNumber",
    "/document/#{c}/faxNumberGroupList/faxNumberGroup/faxNumberType",
    "/document/#{c}/webAddressGroupList/webAddressGroup/webAddress",
    "/document/#{c}/webAddressGroupList/webAddressGroup/webAddressType",
    "/document/#{c}/addressGroupList/addressGroup/addressType",
    "/document/#{c}/addressGroupList/addressGroup/addressPlace1",
    "/document/#{c}/addressGroupList/addressGroup/addressPlace2",
    "/document/#{c}/addressGroupList/addressGroup/addressMunicipality",
    "/document/#{c}/addressGroupList/addressGroup/addressStateOrProvince",
    "/document/#{c}/addressGroupList/addressGroup/addressPostCode",
    "/document/#{c}/addressGroupList/addressGroup/addressCountry",
    { xpath: "/document/#{ext}/currentPlace", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{ext}/socialMediaGroupList/socialMediaGroup[1]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{ext}/socialMediaGroupList/socialMediaGroup[1]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/#{ext}/socialMediaGroupList/socialMediaGroup[2]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{ext}/socialMediaGroupList/socialMediaGroup[2]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    "/document/#{ext}/socialMediaGroupList/socialMediaGroup/socialMediaHandle",
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('publicart', 'Org_auth_publicart.csv', 15) }
    let(:doc) { get_doc(publicartorganization) }
    let(:record) { get_fixture('publicart_organization_row15.xml') }
    let(:xpath_required) {[
      "/document/*/orgTermGroupList/orgTermGroup/termDisplayName"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
