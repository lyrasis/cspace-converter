require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CorePerson do
  let(:attributes) { get_attributes('core', 'authperson_core_all.csv') }
  let(:coreperson) { CorePerson.new(Lookup.profile_defaults('person').merge(attributes)) }
  let(:doc) { get_doc(coreperson) }
  let(:record) { get_fixture('core_person.xml') }
  let(:p) { 'persons_common' }
  let(:ext) { 'contacts_common' }
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
    "/document/#{p}/personTermGroupList/personTermGroup/termType",
    "/document/#{p}/personTermGroupList/personTermGroup/termQualifier",
    { xpath: "/document/#{p}/personTermGroupList/personTermGroup/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/personTermGroupList/personTermGroup/termSourceID",
    "/document/#{p}/personTermGroupList/personTermGroup/termSourceDetail",
    "/document/#{p}/personTermGroupList/personTermGroup/termSourceNote",
    "/document/#{p}/personTermGroupList/personTermGroup/termStatus",
    "/document/#{p}/personTermGroupList/personTermGroup/termFormattedDisplayName",
    { xpath: "/document/#{p}/birthDateGroup/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/#{p}/deathDateGroup/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    "/document/#{p}/birthPlace",
    "/document/#{p}/deathPlace",
    "/document/#{p}/groups/group",
    "/document/#{p}/nationalities/nationality",
    "/document/#{p}/gender",
    "/document/#{p}/occupations/occupation",
    "/document/#{p}/schoolsOrStyles/schoolOrStyle",
    "/document/#{p}/bioNote",
    "/document/#{p}/nameNote",
    "/document/#{ext}/emailGroupList/emailGroup/email",
    "/document/#{ext}/emailGroupList/emailGroup/emailType",
    "/document/#{ext}/telephoneNumberGroupList/telephoneNumberGroup/telephoneNumber",
    "/document/#{ext}/telephoneNumberGroupList/telephoneNumberGroup/telephoneNumberType",
    "/document/#{ext}/faxNumberGroupList/faxNumberGroup/faxNumber",
    "/document/#{ext}/faxNumberGroupList/faxNumberGroup/faxNumberType",
    "/document/#{ext}/webAddressGroupList/webAddressGroup/webAddress",
    "/document/#{ext}/webAddressGroupList/webAddressGroup/webAddressType",
    "/document/#{ext}/addressGroupList/addressGroup/addressType",
    "/document/#{ext}/addressGroupList/addressGroup/addressPlace1",
    "/document/#{ext}/addressGroupList/addressGroup/addressPlace2",
    "/document/#{ext}/addressGroupList/addressGroup/addressMunicipality",
    "/document/#{ext}/addressGroupList/addressGroup/addressStateOrProvince",
    "/document/#{ext}/addressGroupList/addressGroup/addressPostCode",
    "/document/#{ext}/addressGroupList/addressGroup/addressCountry",
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'authperson_core_all.csv', 3) }
    let(:doc) { get_doc(coreperson) }
    let(:record) { get_fixture('core_person_row3.xml') }
    let(:xpath_required) {[
      "/document/*/personTermGroupList/personTermGroup/termDisplayName"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
