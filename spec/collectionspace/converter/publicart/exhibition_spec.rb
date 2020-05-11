require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtExhibition do
  let(:attributes) { get_attributes('publicart', 'exhibition_publicart_all.csv') }
  let(:publicartexhibition) { PublicArtExhibition.new(attributes) }
  let(:doc) { Nokogiri::XML(publicartexhibition.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('publicart_exhibition.xml') }
  let(:p) { 'exhibitions_common' }
  let(:ext) { 'exhibitions_publicart' }
  let(:xpaths) {[
    "/document/#{p}/exhibitionNumber",
    "/document/#{p}/title",
    { xpath: "/document/#{p}/type", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/venueGroupList/venueGroup[1]/venue", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/venueGroupList/venueGroup[2]/venue", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/venueGroupList/venueGroup/venueOpeningDate",
    "/document/#{p}/venueGroupList/venueGroup/venueUrl",
    "/document/#{p}/venueGroupList/venueGroup/venueAttendance",
    "/document/#{p}/venueGroupList/venueGroup/venueClosingDate",
    "/document/#{p}/planningNote",
    "/document/#{p}/curatorialNote",
    "/document/#{p}/generalNote",
    "/document/#{p}/boilerplateText",
    { xpath: "/document/#{p}/organizers/organizer[1]", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/organizers/organizer[2]", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/organizers/organizer[3]", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/galleryRotationGroupList/galleryRotationGroup/galleryRotationName",
    "/document/#{p}/galleryRotationGroupList/galleryRotationGroup/galleryRotationStartDateGroup/dateDisplayDate",
    "/document/#{p}/galleryRotationGroupList/galleryRotationGroup/galleryRotationEndDateGroup/dateDisplayDate",
    "/document/#{p}/galleryRotationGroupList/galleryRotationGroup/galleryRotationNote",
    "/document/#{ext}/exhibitionSupportGroupList/exhibitionSupportGroup/exhibitionSupportNote",
    { xpath: "/document/#{ext}/exhibitionSupportGroupList/exhibitionSupportGroup[1]/exhibitionSupport", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{ext}/exhibitionSupportGroupList/exhibitionSupportGroup[2]/exhibitionSupport", transform: ->(text) { CSURN.parse(text)[:label] } },
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('publicart', 'exhibition_publicart_all.csv', 3) }    
    let(:doc) { Nokogiri::XML(publicartexhibition.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('publicart_exhibition_row3.xml') }
    let(:xpath_required) {[
      "/document/*/exhibitionNumber"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
