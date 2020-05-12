require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtOrganization do
  let(:attributes) { get_attributes('publicart', 'Org_auth_publicart.csv') }
  let(:publicartorganization) { PublicArtOrganization.new(Lookup.profile_defaults('organization').merge(attributes)) }
  let(:doc) { get_doc(publicartorganization) }
  let(:record) { get_fixture('publicart_organization.xml') }

  describe 'map_common' do
    p = 'organizations_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/contactNames/contactName",
        "/document/#{p}/groups/group",
        "/document/#{p}/functions/function"
      ].each do |xpath|
        context "for xpath: #{xpath}" do
          it 'is empty' do
            expect(get_text(doc, xpath)).to be_empty
          end
        end
      end
    end

    context 'fields overridden by publicart' do
      context 'when local place' do
        [
          "/document/#{p}/foundingPlace"
        ].each do |xpath|
          context "#{xpath}" do
            it 'all values will be URNs' do
              expect(urn_values(doc, xpath)).not_to include('Not a URN')
            end
            
            it 'URNs match sample payload' do
              expect(urn_values(doc, xpath)).to eq(urn_values(record, xpath))
            end
          end
        end
      end
      context 'when shared place' do
        let(:attributes) { get_attributes_by_row('publicart', 'Org_auth_publicart.csv', 3) }
        let(:doc) { get_doc(publicartorganization) }
        let(:record) { get_fixture('publicart_organization_row2.xml') }
        [
          "/document/#{p}/foundingPlace"
        ].each do |xpath|
          context "#{xpath}" do
            it 'all values will be URNs' do
              expect(urn_values(doc, xpath)).not_to include('Not a URN')
            end
            
            it 'URNs match sample payload' do
              expect(urn_values(doc, xpath)).to eq(urn_values(record, xpath))
            end
          end
        end
      end
    end

    # I'm adding this to test whether I need to call this in publicart or whether it
    #  can be handled by core
    context 'when fields defined by contact subrecord' do
    end
  end

  describe 'map_publicart' do
    pa = 'organizations_publicart'
    context 'authority/vocabulary fields' do
      [
        "/document/#{pa}/placementType",
        "/document/#{pa}/currentPlace"
      ].each do |xpath|
        context "#{xpath}" do
          it 'all values will be URNs' do
            expect(urn_values(doc, xpath)).not_to include('Not a URN')
          end
          
          it 'URNs match sample payload' do
            expect(urn_values(doc, xpath)).to eq(urn_values(record, xpath))
          end
        end
      end      
    end
  end

end
