require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreAcquisition do
  let(:attributes) { get_attributes('core', 'acquisition_core_all.csv') }
  let(:coreacquisition) { CoreAcquisition.new(attributes) }
  let(:doc) { get_doc(coreacquisition) }
  let(:record) { get_fixture('core_acquisition_row1.xml') }
  let(:xpaths) {[
    { xpath: '/document/*/acquisitionAuthorizer', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/acquisitionReferenceNumber',
    '/document/*/acquisitionAuthorizerDate',
    '/document/*/accessionDateGroup/scalarValuesComputed',
    '/document/*/accessionDateGroup/dateDisplayDate',
    '/document/*/accessionDateGroup/dateLatestScalarValue',
    '/document/*/accessionDateGroup/dateEarliestSingleDay',
    '/document/*/accessionDateGroup/dateEarliestSingleYear',
    { xpath: '/document/*/accessionDateGroup/dateEarliestSingleEra', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/accessionDateGroup/dateEarliestScalarValue',
    '/document/*/acquisitionDateGroupList/acquisitionDateGroup/scalarValuesComputed',
    '/document/*/acquisitionDateGroupList/acquisitionDateGroup/dateDisplayDate',
    { xpath: '/document/*/acquisitionFundingList/acquisitionFunding[1]/acquisitionFundingCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/acquisitionFundingList/acquisitionFunding[1]/acquisitionFundingCurrency', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/acquisitionFundingList/acquisitionFunding[2]/acquisitionFundingCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/acquisitionFundingList/acquisitionFunding[2]/acquisitionFundingCurrency', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/acquisitionFundingList/acquisitionFunding/acquisitionFundingValue',
    { xpath: '/document/*/acquisitionFundingList/acquisitionFunding/acquisitionFundingSource', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/acquisitionFundingList/acquisitionFunding/acquisitionFundingSourceProvisos',
    '/document/*/acquisitionMethod',
    '/document/*/acquisitionNote',
    '/document/*/acquisitionProvisos',
    '/document/*/acquisitionReason',
    { xpath: '/document/*/owners/owner[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/owners/owner[1]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/owners/owner[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/owners/owner[2]', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/acquisitionSources/acquisitionSource', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/creditLine',
    { xpath: '/document/*/groupPurchasePriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/groupPurchasePriceValue',
    { xpath: '/document/*/objectOfferPriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/objectOfferPriceValue',
    { xpath: '/document/*/objectPurchaseOfferPriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/objectPurchaseOfferPriceValue',
    { xpath: '/document/*/objectPurchasePriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/objectPurchasePriceValue',
    { xpath: '/document/*/originalObjectPurchasePriceCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/originalObjectPurchasePriceValue',
    '/document/*/transferOfTitleNumber',
    '/document/*/fieldCollectionEventNames/fieldCollectionEventName',
    { xpath: '/document/*/approvalGroupList/approvalGroup[1]/approvalGroup', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[1]/approvalGroup', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[2]/approvalGroup', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[2]/approvalGroup', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[1]/approvalIndividual', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[1]/approvalIndividual', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[2]/approvalIndividual', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[2]/approvalIndividual', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[1]/approvalStatus', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[1]/approvalStatus', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[2]/approvalStatus', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[2]/approvalStatus', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/approvalGroupList/approvalGroup/approvalDate',
    '/document/*/approvalGroupList/approvalGroup/approvalNote',
  ]}

  context 'sample data row 1' do
  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
 end
  context 'sample data row 32' do
      let(:attributes) { get_attributes_by_row('core', 'acquisition_core_all.csv', 32) }
      let(:coreacquisition) { CoreAcquisition.new(attributes) }
      let(:doc) { get_doc(coreacquisition) }
      let(:record) { get_fixture('core_acquisition_row31.xml') }
      let(:xpaths) {[
        '/document/*/acquisitionReferenceNumber',
      ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
 end
end
