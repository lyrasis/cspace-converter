require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtMovement do
  let(:attributes) { get_attributes('publicart', 'lmi_publicart_all.csv') }
  let(:publicartmovement) { PublicArtMovement.new(attributes) }
  let(:doc) { Nokogiri::XML(publicartmovement.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('publicart_movement.xml') }
  let(:xpaths) {[
    '/document/*/movementReferenceNumber',
    { xpath: '/document/*/currentLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/currentLocationFitness',
    '/document/*/currentLocationNote',
    '/document/*/locationDate',
    '/document/*/reasonForMove',
    { xpath: '/document/*/movementContact', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/movementMethods/movementMethod',
    '/document/*/plannedRemovalDate',
    '/document/*/removalDate',
    '/document/*/movementNote',
  ]}
 
  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('publicart', 'lmi_publicart_all.csv', 11) }
    let(:doc) { Nokogiri::XML(publicartmovement.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('publicart_movement_row11.xml') }
    let(:xpath_required) {[
      { xpath: '/document/*/currentLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
