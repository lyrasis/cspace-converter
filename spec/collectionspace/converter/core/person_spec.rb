require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CorePerson do
  let(:attributes) { get_attributes('core', 'authperson_core_all.csv') }
  let(:coreperson) { CorePerson.new(Lookup.profile_defaults('person').merge(attributes)) }
  let(:doc) { Nokogiri::XML(coreperson.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_person.xml') }
  let(:xpaths) {[
    '/document/*/personTermGroupList/personTermGroup/termDisplayName',
    '/document/*/personTermGroupList/personTermGroup/termName',
    '/document/*/personTermGroupList/personTermGroup/foreName',
    '/document/*/personTermGroupList/personTermGroup/middleName',
    '/document/*/personTermGroupList/personTermGroup/surName',
    '/document/*/personTermGroupList/personTermGroup/initials',
    '/document/*/personTermGroupList/personTermGroup/salutation',
    '/document/*/personTermGroupList/personTermGroup/title',
    '/document/*/personTermGroupList/personTermGroup/nameAdditions',
    { xpath: '/document/*/personTermGroupList/personTermGroup/termLanguage', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    '/document/*/personTermGroupList/personTermGroup/termPrefForLang',
    '/document/*/personTermGroupList/personTermGroup/termType',
    '/document/*/personTermGroupList/personTermGroup/termQualifier',
    { xpath: '/document/*/personTermGroupList/personTermGroup/termSource', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/personTermGroupList/personTermGroup/termSourceID',
    '/document/*/personTermGroupList/personTermGroup/termSourceDetail',
    '/document/*/personTermGroupList/personTermGroup/termSourceNote',
    '/document/*/personTermGroupList/personTermGroup/termStatus',
    { xpath: '/document/*/birthDateGroup/dateDisplayDate', transform: ->(text) { text.split('-')[0] } },
    { xpath: '/document/*/deathDateGroup/dateDisplayDate', transform: ->(text) { text.split('-')[0] } },
    '/document/*/birthPlace',
    '/document/*/deathPlace',
    '/document/*/groups/group',
    '/document/*/nationalities/nationality',
    '/document/*/gender',
    '/document/*/occupations/occupation',
    '/document/*/schoolsOrStyles/schoolOrStyle',
    '/document/*/bioNote',
    '/document/*/nameNote',
    '/document/*/emailGroupList/emailGroup/email',
    '/document/*/emailGroupList/emailGroup/emailType',
    '/document/*/telephoneNumberGroupList/telephoneNumberGroup/telephoneNumber',
    '/document/*/telephoneNumberGroupList/telephoneNumberGroup/telephoneNumberType',
    '/document/*/faxNumberGroupList/faxNumberGroup/faxNumber',
    '/document/*/faxNumberGroupList/faxNumberGroup/faxNumberType',
    '/document/*/webAddressGroupList/webAddressGroup/webAddress',
    '/document/*/webAddressGroupList/webAddressGroup/webAddressType',
    '/document/*/addressGroupList/addressGroup/addressType',
    '/document/*/addressGroupList/addressGroup/addressPlace1',
    '/document/*/addressGroupList/addressGroup/addressPlace2',
    '/document/*/addressGroupList/addressGroup/addressMunicipality',
    '/document/*/addressGroupList/addressGroup/addressStateOrProvince',
    '/document/*/addressGroupList/addressGroup/addressPostCode',
    '/document/*/addressGroupList/addressGroup/addressCountry',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
