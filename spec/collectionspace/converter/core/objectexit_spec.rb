require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreObjectExit do
  let(:attributes) { get_attributes('core', 'objectexit_core_all.csv') }
  let(:coreobjectexit) { CoreObjectExit.new(attributes) }
  let(:doc) { Nokogiri::XML(coreobjectexit.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_objectexit.xml') }
  let(:xpaths) {[
    '/document/*/exitNumber',
    { xpath: '/document/*/currentOwner', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/depositor', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/exitDateGroup',
    '/document/*/exitMethods/exitMethod',
    '/document/*/exitNote',
    '/document/*/exitQuantity',
    '/document/*/exitReason',
    '/document/*/packingNote',
    '/document/*/displosalNewObjectNumber',
    { xpath: '/document/*/deacApprovalGroupList/deacApprovalGroup[1]/deaccessionApprovalStatus', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/deacApprovalGroupList/deacApprovalGroup[1]/deaccessionApprovalGroup', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    '/document/*/deacApprovalGroupList/deacApprovalGroup/deaccessionApprovalDate',
    { xpath: '/document/*/deaccessionAuthorizer', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/authorizationDate',
    '/document/*/deaccessionDate',
    '/document/*/disposalDate',
    { xpath: '/document/*/disposalMethod', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    '/document/*/displosalReason',
    '/document/*/displosalProvisos',
    { xpath: '/document/*/disposalProposedRecipient', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/disposalRecipient', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/displosalNote',
    { xpath: '/document/*/disposalCurrency', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    '/document/*/displosalValue',
    { xpath: '/document/*/groupDisposalCurrency', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    '/document/*/groupDisplosalValue',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
