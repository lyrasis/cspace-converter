require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtPlace do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'publicart.collectionspace.org'
  end

  let(:publicartplace) { PublicArtPlace.new(attributes) }
  let(:p) { 'places_common' }
  let(:ext) { 'places_publicart' }

  let(:attributes) { get_attributes('publicart', 'place_authority.csv') }
  let(:doc) { get_doc(publicartplace) }
  let(:record) { get_fixture('publicart_place.xml') }
  let(:xpaths) {[
    "/document/#{p}/placeTermGroupList/placeTermGroup/termDisplayName",
    { xpath: "/document/#{p}/placeTermGroupList/placeTermGroup/termLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/#{p}/placeTermGroupList/placeTermGroup/termPrefForLang",
    "/document/#{p}/placeTermGroupList/placeTermGroup/termType",
    "/document/#{p}/placeTermGroupList/placeTermGroup/termQualifier",
    { xpath: "/document/#{p}/placeTermGroupList/placeTermGroup/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/placeTermGroupList/placeTermGroup/termSourceID",
    "/document/#{p}/placeTermGroupList/placeTermGroup/termSourceDetail",
    "/document/#{p}/placeTermGroupList/placeTermGroup/termSourceNote",
    "/document/#{p}/placeTermGroupList/placeTermGroup/termStatus",
    "/document/#{p}/placeTermGroupList/placeTermGroup/termName",
    { xpath: "/document/#{p}/placeTermGroupList/placeTermGroup/termFlag", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/placeTermGroupList/placeTermGroup/nameAbbrev",
    "/document/#{p}/placeTermGroupList/placeTermGroup/nameNote",
    "/document/#{p}/placeTermGroupList/placeTermGroup/historicalStatus",
    "/document/#{p}/placeTermGroupList/placeTermGroup/nameDateGroup/dateDisplayDate",
    { xpath: "/document/#{ext}/publicArtPlaceTypes/publicArtPlaceType[1]", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{ext}/publicArtPlaceTypes/publicArtPlaceType[1]", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/#{ext}/publicArtPlaceTypes/publicArtPlaceType[2]", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{ext}/publicArtPlaceTypes/publicArtPlaceType[2]", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/#{ext}/placementTypes/placementType[1]", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{ext}/placementTypes/placementType[1]", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/#{ext}/placementTypes/placementType[2]", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{ext}/placementTypes/placementType[2]", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    "/document/#{ext}/placementEnvironment",
    { xpath: "/document/#{ext}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup[1]/owner", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{ext}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup[1]/owner", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/#{ext}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup[2]/owner", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{ext}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup[2]/owner", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    "/document/#{ext}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup/ownershipNote",
    "/document/#{ext}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup/ownershipDateGroup/dateDisplayDate",
    "/document/#{ext}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup/ownerType",
    "/document/#{p}/placeNote",
    { xpath: "/document/#{p}/addrGroupList/addrGroup[1]/addressCountry", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[1]/addressCountry", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[2]/addressCountry", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[2]/addressCountry", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[1]/addressCounty", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[1]/addressCounty", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[2]/addressCounty", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[2]/addressCounty", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    "/document/#{p}/addrGroupList/addrGroup/addressPlace2",
    "/document/#{p}/addrGroupList/addrGroup/addressPlace1",
    { xpath: "/document/#{p}/addrGroupList/addrGroup[1]/addressType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[1]/addressType", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[2]/addressType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[2]/addressType", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[1]/addressMunicipality", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[1]/addressMunicipality", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[2]/addressMunicipality", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[2]/addressMunicipality", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[1]/addressStateOrProvince", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[1]/addressStateOrProvince", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[2]/addressStateOrProvince", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/addrGroupList/addrGroup[2]/addressStateOrProvince", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    "/document/#{p}/addrGroupList/addrGroup/addressPostCode",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/geoRefProtocol",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/geoRefSource",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/coordPrecision",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/footprintWKT",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/decimalLongitude",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/geoRefDateGroup/dateDisplayDate",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/decimalLatitude",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/geodeticDatum",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/pointRadiusSpatialFit",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/geoRefRemarks",
    { xpath: "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup[1]/geoReferencedBy", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup[1]/geoReferencedBy", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup[2]/geoReferencedBy", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup[2]/geoReferencedBy", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/geoRefPlaceName",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/footprintSRS",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/footprintSpatialFit",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/geoRefVerificationStatus",
    "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/coordUncertaintyInMeters"
  ]}
 
  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('publicart', 'place_authority.csv', 3) }
    let(:doc) { Nokogiri::XML(publicartplace.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('publicart_place_row3.xml') }
    let(:xpath_required) {[
      "/document/*/placeTermGroupList/placeTermGroup/termDisplayName"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
