require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Extension::Contact do
  let(:attributes) { get_attributes('publicart', 'Org_auth_publicart.csv') }
  let(:publicartorganization) { PublicArtOrganization.new(Lookup.profile_defaults('organization').merge(attributes)) }
  let(:doc) { get_doc(publicartorganization) }
  let(:record) { get_fixture('publicart_organization.xml') }

  describe 'map_contact' do
    context 'text fields' do
      [
        "/document/*/addressGroupList/addressGroup/addressCountry",
        "/document/*/addressGroupList/addressGroup/addressMunicipality",
        "/document/*/addressGroupList/addressGroup/addressPlace1",
        "/document/*/addressGroupList/addressGroup/addressPlace2",
        "/document/*/addressGroupList/addressGroup/addressPostCode",
        "/document/*/addressGroupList/addressGroup/addressStateOrProvince",
        "/document/*/addressGroupList/addressGroup/addressType",
        "/document/*/emailGroupList/emailGroup/email",
        "/document/*/emailGroupList/emailGroup/emailType",
        "/document/*/faxNumberGroupList/faxNumberGroup/faxNumber",
        "/document/*/faxNumberGroupList/faxNumberGroup/faxNumberType",
        "/document/*/telephoneNumberGroupList/telephoneNumberGroup/telephoneNumber",
        "/document/*/telephoneNumberGroupList/telephoneNumberGroup/telephoneNumberType",
        "/document/*/webAddressGroupList/webAddressGroup/webAddress",
        "/document/*/webAddressGroupList/webAddressGroup/webAddressType"
      ].each do |xpath|
        context "for xpath: #{xpath}" do
          it 'is populated' do
            expect(get_text(doc, xpath)).to_not be_empty
          end
          
          it 'matches sample payload' do
            expect(get_text(doc, xpath)).to eq(get_text(record, xpath))
          end
        end
      end
    end
  end
end

