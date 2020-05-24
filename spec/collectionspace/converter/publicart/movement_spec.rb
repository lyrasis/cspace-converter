require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtMovement do
  let(:attributes) { get_attributes('publicart', 'lmi_publicart_all.csv') }
  let(:publicartmovement) { PublicArtMovement.new(Lookup.profile_defaults('movement').merge(attributes)) }
  let(:doc) { get_doc(publicartmovement) }
  let(:record) { get_fixture('publicart_movement.xml') }

  describe 'map_common' do
    p = 'movements_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/normalLocation",
        "/document/#{p}/inventoryActionRequired",
        "/document/#{p}/frequencyForInventory",
        "/document/#{p}/inventoryDate",
        "/document/#{p}/nextInventoryDate",
        "/document/#{p}/inventoryContactList/inventoryContact",
        "/document/#{p}/inventoryNote",
      ].each do |xpath|
        context "#{xpath}" do
          it 'is empty' do
            verify_field_is_empty(doc, xpath)
          end
        end
      end
    end

    context 'fields overridden by publicart' do
      context 'authority/vocab fields' do
        [
          "/document/#{p}/currentLocation",
          "/document/#{p}/movementContact"
        ].each do |xpath|
          context "#{xpath}" do
            let(:urn_vals) { urn_values(doc, xpath) }
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end

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
end
