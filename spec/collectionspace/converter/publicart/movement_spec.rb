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
        context "for xpath: #{xpath}" do
          it 'is empty' do
            expect(get_text(doc, xpath)).to be_empty
          end
        end
      end
    end

    context 'fields overridden by publicart' do
      context 'when local auth/vocab' do
        [
          "/document/#{p}/currentLocation",
          "/document/#{p}/movementContact"
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
      context 'when shared auth/vocab' do
        let(:attributes) { get_attributes_by_row('publicart', 'lmi_publicart_all.csv', 3) }
        let(:doc) { get_doc(publicartmovement) }
        let(:record) { get_fixture('publicart_movement_row3.xml') }
        [
          "/document/#{p}/currentLocation",
          "/document/#{p}/movementContact"
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
end
