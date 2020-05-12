require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Extension::CulturalCare do
  let(:attributes) { get_attributes('lhmc', 'collectionobject_partial.csv') }
  let(:co) { LhmcCollectionObject.new(attributes) }
  let(:doc) { get_doc(co) }
  let(:record) { get_fixture('lhmc_collectionobject_row2.xml') }

  describe 'map_cultural_care' do
    cc = 'collectionobject_culturalcare'
    context 'text field' do
      [
        "/document/#{cc}/culturalCareNotes/culturalCareNote",
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/limitationDetails",
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/requestDate"
      ].each do |xpath|
        context "for xpath: #{xpath}" do
          it 'matches sample payload' do
            expect(get_text(doc, xpath)).to eq(get_text(record, xpath))
          end
        end
      end
    end

      context 'vocab field' do
      [
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/requester",
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/limitationLevel",
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/limitationType",
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/requestOnBehalfOf"
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

