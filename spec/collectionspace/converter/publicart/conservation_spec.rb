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
        "/document/#{p}/destAnalysisGroupList/destAnalysisGroup/sampleReturnedLocation"
      ].each do |xpath|
        context "#{xpath}" do
          it 'is empty' do
            verify_field_is_empty(doc, xpath)
          end
        end
      end
    end

    context 'fields overridden by publicart' do
      context 'when local authority/vocab fields' do
        [
          "/document/#{p}/conservators/conservator",
          "/document/#{p}/otherPartyGroupList/otherPartyGroup/otherParty",
          "/document/#{p}/examinationGroupList/examinationGroup/examinationStaff",
          "/document/#{p}/approvedBy",
          "/document/#{p}/researcher"
        ].each do |xpath|
          context "#{xpath}" do
            let(:urn_vals) { urn_values(doc, xpath) }
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end

            it 'values are URNs' do
              verify_values_are_urns(urn_vals)
            end
            
            it 'URNs match sample payload' do
              verify_urn_match(urn_vals, record, xpath)
            end
          end
        end
      end

      context 'when shared authority/vocab fields' do
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
            let(:urn_vals) { urn_values(doc, xpath) }
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end

            it 'values are URNs' do
              verify_values_are_urns(urn_vals)
            end
            
            it 'URNs match sample payload' do
              verify_urn_match(urn_vals, record, xpath)
            end
          end
        end
      end

      
    end
  end

  describe 'map_publicart' do
    pa = 'conservation_publicart'
    context 'non-authority/vocab fields' do
      [
        "/document/#{pa}/conservationPriorityLevel",
        "/document/#{pa}/proposedTreatmentStartDate",
        "/document/#{pa}/proposedTreatmentEndDate",
        "/document/#{pa}/proposedTreatmentEstValue",
        "/document/#{pa}/proposedTreatmentContractRestrictions",
        "/document/#{pa}/analysisRecommendations",
        "/document/#{pa}/treatmentCostValue"
      ].each do |xpath|
        context "#{xpath}" do
          let(:doctext) { get_text(doc, xpath) }
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end
            
            it 'matches sample payload' do
              verify_value_match(doc, record, xpath)
            end
        end
      end
    end
    
    context 'authority/vocab fields' do
      [
        "/document/#{pa}/proposedTreatmentEstCurrency",
        "/document/#{pa}/treatmentCostCurrency",
      ].each do |xpath|
        context "#{xpath}" do
          let(:urn_vals) { urn_values(doc, xpath) }
          it 'is not empty' do
            verify_field_is_populated(doc, xpath)
          end

          it 'values are URNs' do
            verify_values_are_urns(urn_vals)
          end
          
          it 'URNs match sample payload' do
            verify_urn_match(urn_vals, record, xpath)
          end
        end
      end
    end
  end
end 
