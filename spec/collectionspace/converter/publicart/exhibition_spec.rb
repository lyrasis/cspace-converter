require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtExhibition do
  let(:attributes) { get_attributes('publicart', 'exhibition_publicart_all.csv') }
  let(:publicartexhibition) { PublicArtExhibition.new(Lookup.profile_defaults('exhibition').merge(attributes)) }
  let(:doc) { get_doc(publicartexhibition) }
  let(:record) { get_fixture('publicart_exhibition.xml') }

  describe 'map_common' do
    p = 'exhibitions_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/sponsors/sponsor",
        "/document/#{p}/workingGroupList/workingGroup/workingGroupTitle",
        "/document/#{p}/workingGroupList/workingGroup/workingGroupNote",
        "/document/#{p}/workingGroupList/workingGroup/exhibitionPersonGroupList/exhibitionPersonGroup/exhibitionPerson",
        "/document/#{p}/workingGroupList/workingGroup/exhibitionPersonGroupList/exhibitionPersonGroup/exhibitionPersonRole",
        "/document/#{p}/exhibitionReferenceGroupList/exhibitionReferenceGroup/exhibitionReference",
        "/document/#{p}/exhibitionReferenceGroupList/exhibitionReferenceGroup/exhibitionReferenceType",
        "/document/#{p}/exhibitionReferenceGroupList/exhibitionReferenceGroup/exhibitionReferenceNote",
        "/document/#{p}/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionName",
        "/document/#{p}/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionLocation",
        "/document/#{p}/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionObjects",
        "/document/#{p}/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionNote",
        "/document/#{p}/exhibitionStatusGroupList/exhibitionStatusGroup/exhibitionStatus",
        "/document/#{p}/exhibitionStatusGroupList/exhibitionStatusGroup/exhibitionStatusDate",
        "/document/#{p}/exhibitionStatusGroupList/exhibitionStatusGroup/exhibitionStatusNote",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectNumber",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectName",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectConsCheckDate",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectConsTreatment",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectMount",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectSection",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectCase",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectSeqNum",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectRotation",
        "/document/#{p}/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectNote"
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
          "/document/#{p}/organizers/organizer",
          "/document/#{p}/venueGroupList/venueGroup/venue"
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
      context 'when shared vocab/auth' do
        let(:attributes) { get_attributes_by_row('publicart', 'exhibition_publicart_all.csv', 4) }
        let(:doc) { get_doc(publicartexhibition) }
        let(:record) { get_fixture('publicart_exhibition_row4.xml') }
        [
          "/document/#{p}/organizers/organizer",
          "/document/#{p}/venueGroupList/venueGroup/venue"
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
    pa = 'exhibitions_publicart'
    context 'authority/vocabulary fields' do
      [
        "/document/#{pa}/exhibitionSupportGroupList/exhibitionSupportGroup/exhibitionSupport",
        "/document/#{pa}/exhibitionSupportGroupList/exhibitionSupportGroup/exhibitionSupportNote"
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
