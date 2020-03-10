require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CorePlace do
  let(:attributes) { get_attributes('core', 'place_core_all.csv') }
  let(:coreplace) { CorePlace.new(attributes) }
  let(:doc) { Nokogiri::XML(coreplace.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_place.xml') }
  let(:xpaths) {[
    "/document/*/placeTermGroupList/placeTermGroup/termDisplayName",
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[1]/termLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[1]/termLanguage", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[2]/termLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[2]/termLanguage", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    "/document/*/placeTermGroupList/placeTermGroup/termPrefForLang",
    "/document/*/placeTermGroupList/placeTermGroup/termType",
    "/document/*/placeTermGroupList/placeTermGroup/termQualifier",
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[1]/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[1]/termSource", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[2]/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[2]/termSource", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    "/document/*/placeTermGroupList/placeTermGroup/termSourceID",
    "/document/*/placeTermGroupList/placeTermGroup/termSourceDetail",
    "/document/*/placeTermGroupList/placeTermGroup/termSourceNote",
    "/document/*/placeTermGroupList/placeTermGroup/termStatus",
    "/document/*/placeTermGroupList/placeTermGroup/termName",
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[1]/termFlag", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[1]/termFlag", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[2]/termFlag", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/placeTermGroupList/placeTermGroup[2]/termFlag", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    "/document/*/placeTermGroupList/placeTermGroup/nameAbbrev",
    "/document/*/placeTermGroupList/placeTermGroup/nameNote",
    "/document/*/placeTermGroupList/placeTermGroup/historicalStatus",
    "/document/*/placeTermGroupList/placeTermGroup/nameDateGroup/dateDisplayDate",
    "/document/*/placeType",
    { xpath: "/document/*/placeOwnerGroupList/placeOwnerGroup[1]/owner", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/placeOwnerGroupList/placeOwnerGroup[1]/owner", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/*/placeOwnerGroupList/placeOwnerGroup[2]/owner", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/placeOwnerGroupList/placeOwnerGroup[2]/owner", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    "/document/*/placeOwnerGroupList/placeOwnerGroup/ownershipNote",
    "/document/*/placeOwnerGroupList/placeOwnerGroup/ownershipDateGroup/dateDisplayDate",
    "/document/*/placeSource",
    "/document/*/placeNote",
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressCountry", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressCountry", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressCountry", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressCountry", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    "/document/*/addrGroupList/addrGroup/addressPlace2",
    "/document/*/addrGroupList/addrGroup/addressPlace1",
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressType", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressType", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressMunicipality", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressMunicipality", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressMunicipality", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressMunicipality", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressStateOrProvince", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/addrGroupList/addrGroup[1]/addressStateOrProvince", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressStateOrProvince", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/addrGroupList/addrGroup[2]/addressStateOrProvince", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    "/document/*/addrGroupList/addrGroup/addressPostCode",
    "/document/*/vCoordinates",
    "/document/*/vLatitude",
    "/document/*/vLongitude",
    "/document/*/vCoordSys",
    "/document/*/vSpatialReferenceSystem",
    "/document/*/vCoordSource",
    "/document/*/vCoordSourceRefId",
    "/document/*/vUnitofMeasure",
    "/document/*/vElevation",
    "/document/*/minElevationInMeters",
    "/document/*/maxElevationInMeters",
    "/document/*/vDepth",
    "/document/*/minDepthInMeters",
    "/document/*/maxDepthInMeters",
    "/document/*/vDistanceAboveSurface",
    "/document/*/minDistanceAboveSurfaceInMeters",
    "/document/*/maxDistanceAboveSurfaceInMeters",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/geoRefProtocol",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/geoRefSource",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/coordPrecision",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/footprintWKT",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/decimalLongitude",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/geoRefDateGroup/dateDisplayDate",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/decimalLatitude",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/geodeticDatum",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/pointRadiusSpatialFit",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/geoRefRemarks",
    { xpath: "/document/*/placeGeoRefGroupList/placeGeoRefGroup[1]/geoReferencedBy", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/placeGeoRefGroupList/placeGeoRefGroup[1]/geoReferencedBy", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/*/placeGeoRefGroupList/placeGeoRefGroup[2]/geoReferencedBy", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/placeGeoRefGroupList/placeGeoRefGroup[2]/geoReferencedBy", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/geoRefPlaceName",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/footprintSRS",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/footprintSpatialFit",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/geoRefVerificationStatus",
    "/document/*/placeGeoRefGroupList/placeGeoRefGroup/coordUncertaintyInMeters"
    
  ]}
  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'place_core_all.csv', 12) }
    let(:doc) { Nokogiri::XML(coreplace.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_place_row12.xml') }
    let(:xpath_required) {[
      "/document/*/placeTermGroupList/placeTermGroup/termDisplayName"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
