require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreMovement do
  let(:attributes) { get_attributes('core', 'lmi_core_all.csv') }
  let(:coremovement) { CoreMovement.new(attributes) }
  let(:doc) { Nokogiri::XML(coremovement.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_movement.xml') }
  let(:xpaths) {[
    '/document/*/movementReferenceNumber',
    { xpath: '/document/*/normalLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
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
    '/document/*/inventoryActionRequired',
    '/document/*/frequencyForInventory',
    '/document/*/inventoryDate',
    '/document/*/nextInventoryDate',
    { xpath: '/document/*/inventoryContactList/inventoryContact', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/inventoryNote',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
