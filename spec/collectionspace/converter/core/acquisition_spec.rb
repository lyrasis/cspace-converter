require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreAcquisition do
  let(:attributes) { get_attributes('core', 'acquisition_core_all.csv') }
  let(:coreacquisition) { CoreAcquisition.new(attributes) }
  let(:doc) { Nokogiri::XML(coreacquisition.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_acquisition.xml') }
  let(:xpaths) {[
    { xpath: '/document/*/acquisitionAuthorizer', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/acquisitionReferenceNumber',
    '/document/*/acquisitionAuthorizerDate',
    '/document/*/accessionDateGroup/dateDisplayDate',
    '/document/*/accessionDateGroup/dateEarliestScalarValue',
    '/document/*/accessionDateGroup/dateLatestScalarValue',
    '/document/*/acquisitionDateGroupList/acquisitionDateGroup/dateDisplayDate',
    '/document/*/acquisitionDateGroupList/acquisitionDateGroup/dateEarliestScalarValue',
    '/document/*/acquisitionDateGroupList/acquisitionDateGroup/dateLatestScalarValue',
    { xpath: '/document/*/acquisitionFundingList/acquisitionFunding/acquisitionFundingCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/acquisitionFundingList/acquisitionFunding/acquisitionFundingValue',
    { xpath: '/document/*/acquisitionFundingList/acquisitionFunding/acquisitionFundingSource', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/acquisitionFundingList/acquisitionFunding/acquisitionFundingSourceProvisos',
    '/document/*/acquisitionMethod',
    '/document/*/acquisitionNote',
    '/document/*/acquisitionProvisos',
    '/document/*/acquisitionReason',
    { xpath: '/document/*/owners/owner', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/acquisitionSources/acquisitionSource', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/creditLine',
    { xpath: '/document/*/groupPurchasePriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/groupPurchasePriceValue',
    # { xpath: '/document/*/objectOfferPriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    # '/document/*/objectOfferPriceValue',
    # { xpath: '/document/*/objectPurchaseOfferPriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    # '/document/*/objectPurchaseOfferPriceValue',
    # { xpath: '/document/*/objectPurchasePriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    # '/document/*/objectPurchasePriceValue',
    # { xpath: '/document/*/originalObjectPurchasePriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    # '/document/*/originalObjectPurchasePriceValue',
    # '/document/*/transferOfTitleNumber',
    '/document/*/fieldCollectionEventNames/fieldCollectionEventName',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
