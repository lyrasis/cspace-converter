require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtValuationControl do
  let(:attributes) { get_attributes('publicart', 'valuationcontrol_publicart_all.csv') }
  let(:publicartvaluationcontrol) { PublicArtValuationControl.new(Lookup.profile_defaults('valuationcontrol').merge(attributes)) }
  let(:doc) { get_doc(publicartvaluationcontrol) }
  let(:record) { get_fixture('publicart_valuation.xml') }

  describe 'map_common' do
    p = 'valuationcontrols_common'
    context 'fields overridden by publicart' do
      context 'when local value source' do
        [
          "/document/#{p}/valueSource"
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
      context 'when shared value source' do
        let(:attributes) { get_attributes_by_row('publicart', 'valuationcontrol_publicart_all.csv', 3) }
        let(:doc) { get_doc(publicartvaluationcontrol) }
        let(:record) { get_fixture('publicart_valuation_row3.xml') }
        [
          "/document/#{p}/valueSource"
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

  describe 'map_publicart' do
    pa = 'valuationcontrols_publicart'
    context 'authority/vocabulary fields' do
      [
        "/document/#{pa}/valueSourceRole",
        "/document/#{pa}/insuranceGroupList/insuranceGroup/insurer",
        "/document/#{pa}/insuranceGroupList/insuranceGroup/insuranceNote",
        "/document/#{pa}/insuranceGroupList/insuranceGroup/insurancePolicyNumber",
        "/document/#{pa}/insuranceGroupList/insuranceGroup/insuranceRenewalDate",

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
