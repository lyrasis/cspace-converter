require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreExhibition do
  let(:attributes) { get_attributes('core', 'exhibition_core_all.csv') }
  let(:coreexhibition) { CoreExhibition.new(attributes) }
  let(:doc) { Nokogiri::XML(coreexhibition.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_exhibition.xml') }
  let(:xpaths) {[
    '/document/*/exhibitionNumber',
    '/document/*/title',
    { xpath: '/document/*/type', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/venueGroupList/venueGroup[1]/venue', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/venueGroupList/venueGroup[2]/venue', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/venueGroupList/venueGroup/venueOpeningDate',
    '/document/*/venueGroupList/venueGroup/venueUrl',
    '/document/*/venueGroupList/venueGroup/venueAttendance',
    '/document/*/venueGroupList/venueGroup/venueClosingDate',
    '/document/*/planningNote',
    '/document/*/curatorialNote',
    '/document/*/generalNote',
    '/document/*/boilerplateText',
    '/document/*/workingGroupList/workingGroup/workingGroupTitle',
    '/document/*/workingGroupList/workingGroup/workingGroupNote',
#    { xpath: '/document/*/workingGroupList/workingGroup/exhibitionPersonGroupList/exhibitionPersonGroup/exhibitionPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/workingGroupList/workingGroup/exhibitionPersonGroupList/exhibitionPersonGroup/exhibitionPersonRole', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/organizers/organizer[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/organizers/organizer[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/organizers/organizer[3]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/sponsors/sponsor[1]', transform: ->(text) { CSURN.parse(text)[:label] } },  
    { xpath: '/document/*/sponsors/sponsor[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/sponsors/sponsor[3]', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/galleryRotationGroupList/galleryRotationGroup/galleryRotationName',
    '/document/*/galleryRotationGroupList/galleryRotationGroup[1]/galleryRotationStartDateGroup/dateDisplayDate',
    '/document/*/galleryRotationGroupList/galleryRotationGroup[2]/galleryRotationStartDateGroup/dateDisplayDate',
    '/document/*/galleryRotationGroupList/galleryRotationGroup[1]/galleryRotationEndDateGroup/dateDisplayDate',
    '/document/*/galleryRotationGroupList/galleryRotationGroup[2]/galleryRotationEndDateGroup/dateDisplayDate',
    '/document/*/galleryRotationGroupList/galleryRotationGroup/galleryRotationNote',
    { xpath: '/document/*/exhibitionReferenceGroupList/exhibitionReferenceGroup[1]/exhibitionReference', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/exhibitionReferenceGroupList/exhibitionReferenceGroup[2]/exhibitionReference', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/exhibitionReferenceGroupList/exhibitionReferenceGroup/exhibitionReferenceNote',
    { xpath: '/document/*/exhibitionReferenceGroupList/exhibitionReferenceGroup/exhibitionReferenceType', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionName',
    '/document/*/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionObjects',
    '/document/*/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionLocation',
    '/document/*/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionNote',
    { xpath: '/document/*/exhibitionStatusGroupList/exhibitionStatusGroup[1]/exhibitionStatus', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/exhibitionStatusGroupList/exhibitionStatusGroup[2]/exhibitionStatus', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/exhibitionStatusGroupList/exhibitionStatusGroup/exhibitionStatusDate',
    '/document/*/exhibitionStatusGroupList/exhibitionStatusGroup/exhibitionStatusNote',
    '/document/*/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectNumber',
    '/document/*/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectName',
    '/document/*/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectConsTreatment',
    '/document/*/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectSection',
    '/document/*/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectCase',
    '/document/*/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectConsCheckDate',
    '/document/*/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectMount',
    '/document/*/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectSeqNum',
    '/document/*/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectNote',
    '/document/*/exhibitionObjectGroupList/exhibitionObjectGroup/exhibitionObjectRotation'
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'exhibition_core_all.csv', 3) }    
    let(:doc) { Nokogiri::XML(coreexhibition.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_exhibition_row3.xml') }
    let(:xpath_required) {[
      '/document/*/exhibitionNumber'
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end

  # has workingGroupList/workingGroup title, note, role values but no person values
  context 'For sample data row 23' do
    let(:attributes) { get_attributes_by_row('core', 'exhibition_core_all.csv', 23) }    
    let(:doc) { Nokogiri::XML(coreexhibition.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_exhibition_row23.xml') }
    let(:xpath_required) {[
      '/document/*/exhibitionNumber'
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
  
end

