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
    { xpath: '/document/*/venueGroupList/venueGroup/venue', transform: ->(text) { CSURN.parse(text)[:label] } },
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
    { xpath: '/document/*/workingGroupList/workingGroup/exhibitionPersonGroupList/exhibitionPersonGroup/exhibitionPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/workingGroupList/workingGroup/exhibitionPersonGroupList/exhibitionPersonGroup/exhibitionPersonRole', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/organizers/organizer', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/sponsors/sponsor', transform: ->(text) { CSURN.parse(text)[:label] } },  
    '/document/*/galleryRotationGroupList/galleryRotationGroup/galleryRotationName',
    '/document/*/galleryRotationGroupList/galleryRotationGroup/galleryRotationStartDateGroup',
    '/document/*/galleryRotationGroupList/galleryRotationGroup/galleryRotationEndDateGroup',
    '/document/*/galleryRotationGroupList/galleryRotationGroup/galleryRotationNote',
    { xpath: '/document/*/exhibitionReferenceGroupList/exhibitionReferenceGroup/exhibitionReference', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/exhibitionReferenceGroupList/exhibitionReferenceGroup/exhibitionReferenceNote',
    { xpath: '/document/*/exhibitionReferenceGroupList/exhibitionReferenceGroup/exhibitionReferenceType', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionName',
    '/document/*/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionObjects',
    '/document/*/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionLocation',
    '/document/*/exhibitionSectionGroupList/exhibitionSectionGroup/exhibitionSectionNote',
    { xpath: '/document/*/exhibitionStatusGroupList/exhibitionStatusGroup/exhibitionStatus', transform: ->(text) { CSURN.parse(text)[:label] } },
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

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end

