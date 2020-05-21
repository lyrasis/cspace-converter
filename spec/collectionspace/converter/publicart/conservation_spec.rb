require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtConservation do
  let(:attributes) { get_attributes('publicart', 'conservation.csv') }
  let(:publicartconservation) { PublicArtConservation.new(Lookup.profile_defaults('conservation').merge(attributes)) }
  let(:doc) { get_doc(publicartconservation) }
  let(:record) { get_fixture('publicart_conservation.xml') }

  describe 'map_common' do
    p = 'conservation_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/destAnalysisGroupList/destAnalysisGroup/destAnalysisApprovedDate",
        "/document/#{p}/destAnalysisGroupList/destAnalysisGroup/destAnalysisApprovalNote",
        "/document/#{p}/destAnalysisGroupList/destAnalysisGroup/sampleBy",
        "/document/#{p}/destAnalysisGroupList/destAnalysisGroup/sampleDate",
        "/document/#{p}/destAnalysisGroupList/destAnalysisGroup/sampleDescription",
        "/document/#{p}/destAnalysisGroupList/destAnalysisGroup/sampleReturned",
        "/document/#{p}/destAnalysisGroupList/destAnalysisGroup/sampleReturnedLocation",
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
          "/document/#{p}/conservators/conservator",
          "/document/#{p}/otherPartyGroupList/otherPartyGroup/otherParty",
          "/document/#{p}/examinationGroupList/examinationGroup/examinationStaff",
          "/document/#{p}/approvedBy",
          "/document/#{p}/researcher"
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
      context 'when shared auth/place' do
        let(:attributes) { get_attributes_by_row('publicart', 'conservation.csv', 3) }
        let(:doc) { get_doc(publicartconservation) }
        let(:record) { get_fixture('publicart_conservation_row3.xml') }
        [
          "/document/#{p}/conservators/conservator",
          "/document/#{p}/otherPartyGroupList/otherPartyGroup/otherParty",
          "/document/#{p}/examinationGroupList/examinationGroup/examinationStaff",
          "/document/#{p}/approvedBy",
          "/document/#{p}/researcher"
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
    pa = 'conservation_publicart'
    context 'authority/vocabulary fields' do
      [
        "/document/#{pa}/conservationPriorityLevel",
        "/document/#{pa}/proposedTreatmentStartDate",
        "/document/#{pa}/proposedTreatmentEndDate",
        "/document/#{pa}/proposedTreatmentEstCurrency",
        "/document/#{pa}/proposedTreatmentEstValue",
        "/document/#{pa}/proposedTreatmentContractRestrictions",
        "/document/#{pa}/treatmentCostCurrency",
        "/document/#{pa}/treatmentCostValue",
        "/document/#{pa}/analysisRecommendations"
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
