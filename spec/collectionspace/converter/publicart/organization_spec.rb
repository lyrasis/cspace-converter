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
        context "#{xpath}" do
          it 'is empty' do
            verify_empty_field(doc, xpath)
          end
        end
      end
    end

    context 'fields overridden by publicart' do
      # foundingPlace is not a repeatable field
      # it does not appear in a repeatablew group
      # therefore, we need 2 rows in the spreadsheet and 2 separate tests
      #  to verify the two different term sources get converted properly
      context 'when local place' do
        [
          "/document/#{p}/foundingPlace"
        ].each do |xpath|
          context "#{xpath}" do
            let(:urn_vals) { urn_values(doc, xpath) }
            it 'values are URNs' do
              verify_values_are_urns(urn_vals)
            end
            
            it 'URNs match sample payload' do
              verify_urn_match(urn_vals, record, xpath)
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
            let(:urn_vals) { urn_values(doc, xpath) }
            it 'values are URNs' do
              verify_values_are_urns(urn_vals)
            end
            
            it 'URNs match sample payload' do
              verify_urn_match(urn_vals, record, xpath)
            end
          end
        end
      end
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
            let(:urn_vals) { urn_values(doc, xpath) }
            it 'values are URNs' do
              verify_values_are_urns(urn_vals)
            end
            
            it 'URNs match sample payload' do
              verify_urn_match(urn_vals, record, xpath)
            end
          end
      end      
    end
  end
end
