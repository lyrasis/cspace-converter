require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtAcquisition do
  let(:attributes) { get_attributes('publicart', 'acquisition_publicart.csv') }
  let(:publicartacquisition) { PublicArtAcquisition.new(Lookup.profile_defaults('acquisition').merge(attributes)) }
  let(:doc) { get_doc(publicartacquisition) }
  let(:record) { get_fixture('publicart_acquisition.xml') }

  describe 'map_common' do
    p = 'acquisitions_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/transferOfTitleNumber",
        "/document/#{p}/groupPurchasePriceCurrency",
        "/document/#{p}/groupPurchasePriceValue",
        "/document/#{p}/objectOfferPriceCurrency",
        "/document/#{p}/objectOfferPriceValue",
        "/document/#{p}/objectPurchaseOfferPriceCurrency",
        "/document/#{p}/objectPurchaseOfferPriceValue",
        "/document/#{p}/objectPurchasePriceCurrency",
        "/document/#{p}/objectPurchasePriceValue",
        "/document/#{p}/originalObjectPurchasePriceCurrency",
        "/document/#{p}/originalObjectPurchasePriceValue",
        "/document/#{p}/approvalGroupList/approvalGroup/approvalGroup",
        "/document/#{p}/approvalGroupList/approvalGroup/approvalIndividual",
        "/document/#{p}/approvalGroupList/approvalGroup/approvalStatus",
        "/document/#{p}/approvalGroupList/approvalGroup/approvalDate",
        "/document/#{p}/approvalGroupList/approvalGroup/approvalNote",
        "/document/#{p}/acquisitionProvisos",
        "/document/#{p}/fieldCollectionEventNames/fieldCollectionEventName",
        "/document/#{p}/accessionDateGroup/dateDisplayDate",
        "/document/#{p}/acquisitionDateGroupList/acquisitionDateGroup/dateDisplayDate",
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
          "/document/#{p}/owner",
          "/document/#{p}/acquisitionSource",
          "/document/#{p}/acquisitionFundingList/acquisitionFunding/acquisitionFundingSource"
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
        let(:attributes) { get_attributes_by_row('publicart', 'acquisition_publicart.csv', 4) }
        let(:doc) { get_doc(publicartacquisition) }
        let(:record) { get_fixture('publicart_acquisition_row4.xml') }
        [
          "/document/#{p}/owner",
          "/document/#{p}/acquisitionSource",
          "/document/#{p}/acquisitionFundingList/acquisitionFunding/acquisitionFundingSource"
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
      context 'when acquisitionMethod vocab' do
        [
          "/document/#{p}/acquisitionMethod"
        ].each do |xpath|
          context "#{xpath}" do
            it 'all values will be URNs' do
              expect(urn_values(doc, xpath)).not_to include('Not a URN')
            end
          end
        end
      end
    end
  end

  describe 'map_publicart' do
    pa = 'acquisitions_publicart'
    context 'publicart fields' do
      [
        "/document/#{pa}/accessionDate",
        "/document/#{pa}/acquisitionDate",
        "/document/#{pa}/acquisitionDate",
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

  describe 'map_commission' do
    ac = 'acquisitions_commission'
    context 'commission fields' do
      [
        "/document/#{ac}/commissionDate",
        "/document/#{ac}/commissioningBody",
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionProjectedValueCurrency",
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionActualValueAmount",
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionBudgetTypeNote",
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionProjectedValueAmount",
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionActualValueCurrency",
        "/document/#{ac}/commissionBudgetGroupList/commissionBudgetGroup/commissionBudgetType"
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
