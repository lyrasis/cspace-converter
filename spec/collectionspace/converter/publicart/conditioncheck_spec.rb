require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtConditionCheck do
  let(:attributes) { get_attributes('publicart', 'condition_check_publicart.csv') }
  let(:publicartconditioncheck) { PublicArtConditionCheck.new(Lookup.profile_defaults('conditioncheck').merge(attributes)) }
  let(:doc) { get_doc(publicartconditioncheck) }
  let(:record) { get_fixture('publicart_conditioncheck.xml') }

  describe 'map_common' do
    p = 'conditionchecks_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/hazardGroupList/hazardGroup/hazardDate",
        "/document/#{p}/hazardGroupList/hazardGroup/hazard",
        "/document/#{p}/hazardGroupList/hazardGroup/hazardNote",
        "/document/#{p}/securityRecommendations",
        "/document/#{p}/storageRequirements",
        "/document/#{p}/packingRecommendations",
        "/document/#{p}/legalReqsHeldGroupList/legalReqsHeldGroup/legalReqsHeldNumber",
        "/document/#{p}/salvagePriorityCodeGroupList/salvagePriorityCodeGroup/salvagePriorityCode",
        "/document/#{p}/salvagePriorityCodeGroupList/salvagePriorityCodeGroup/salvagePriorityCodeDate"
      ].each do |xpath|
        context "for xpath: #{xpath}" do
          it 'is empty' do
            expect(get_text(doc, xpath)).to be_empty
          end
        end
      end
    end

    context 'fields overridden by publicart' do
      context 'when local checker' do
        [
          "/document/#{p}/conditionChecker"
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
      context 'when shared checker' do
        let(:attributes) { get_attributes_by_row('publicart', 'condition_check_publicart.csv', 7) }
        let(:doc) { get_doc(publicartconditioncheck) }
        let(:record) { get_fixture('publicart_conditioncheck_row7.xml') }
        [
          "/document/#{p}/conditionChecker"
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
    pa = 'conditionchecks_publicart'
    context 'test' do
      [
        "/document/#{pa}/installationRecommendations",
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
