require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtPerson do
  let(:attributes) { get_attributes('publicart', 'authperson_publicart_all.csv') }
  let(:publicartperson) { PublicArtPerson.new(Lookup.profile_defaults('person').merge(attributes)) }
  let(:doc) { get_doc(publicartperson) }
  let(:record) { get_fixture('publicart_person.xml') }
  let(:p) { 'persons_common' }
  let(:c) { 'contacts_common' }
  let(:ext) { 'persons_publicart' }
  let(:xpaths) {[
    "/document/#{p}/personTermGroupList/personTermGroup/termDisplayName",
    "/document/#{p}/personTermGroupList/personTermGroup/termName",
    "/document/#{p}/personTermGroupList/personTermGroup/foreName",
    "/document/#{p}/personTermGroupList/personTermGroup/middleName",
    "/document/#{p}/personTermGroupList/personTermGroup/surName",
    "/document/#{p}/personTermGroupList/personTermGroup/initials",
    "/document/#{p}/personTermGroupList/personTermGroup/salutation",
    "/document/#{p}/personTermGroupList/personTermGroup/title",
    "/document/#{p}/personTermGroupList/personTermGroup/nameAdditions",
    { xpath: "/document/#{p}/personTermGroupList/personTermGroup/termLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/#{p}/personTermGroupList/personTermGroup/termPrefForLang",
    { xpath: "/document/#{p}/personTermGroupList/personTermGroup/termType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/#{p}/personTermGroupList/personTermGroup/termQualifier",
    { xpath: "/document/#{p}/personTermGroupList/personTermGroup/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/personTermGroupList/personTermGroup/termSourceID",
    "/document/#{p}/personTermGroupList/personTermGroup/termSourceDetail",
    "/document/#{p}/personTermGroupList/personTermGroup/termSourceNote",
    "/document/#{p}/personTermGroupList/personTermGroup/termStatus",
    { xpath: "/document/#{p}/birthDateGroup/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/#{p}/deathDateGroup/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    "/document/#{p}/birthPlace",
    "/document/#{p}/deathPlace",
    "/document/#{p}/bioNote",
    { xpath: "/document/#{ext}/socialMediaGroupList/socialMediaGroup[1]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{ext}/socialMediaGroupList/socialMediaGroup[1]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/#{ext}/socialMediaGroupList/socialMediaGroup[2]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{ext}/socialMediaGroupList/socialMediaGroup[2]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    "/document/#{ext}/socialMediaGroupList/socialMediaGroup/socialMediaHandle",
    { xpath: "/document/#{ext}/organizations/organization[1]", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{ext}/organizations/organization[2]", transform: ->(text) { CSURN.parse(text)[:label] } },
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
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('publicart', 'authperson_publicart_all.csv', 11) }
    let(:doc) { get_doc(publicartperson) }
    let(:record) { get_fixture('publicart_person_row11.xml') }
    let(:xpath_required) {[
      "/document/*/personTermGroupList/personTermGroup/termDisplayName"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
