require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtPlace do
  let(:attributes) { get_attributes('publicart', 'place_authority.csv') }
  let(:publicartplace) { PublicArtPlace.new(Lookup.profile_defaults('place').merge(attributes)) }
  let(:doc) { get_doc(publicartplace) }
  let(:record) { get_fixture('publicart_place.xml') }

  describe 'map_common' do
    p = 'places_common'
    context 'fields not included in publicart' do
      [
        "/document/#{p}/placeType",
        "/document/#{p}/placeSource",
        "/document/#{p}/placeOwnerGroupList/placeOwnerGroup/owner",
        "/document/#{p}/placeOwnerGroupList/placeOwnerGroup/ownershipNote",
        "/document/#{p}/vCoordinates",
        "/document/#{p}/vLatitude",
        "/document/#{p}/vLongitude",
        "/document/#{p}/vCoordSys",
        "/document/#{p}/vSpatialReferenceSystem",
        "/document/#{p}/vElevation",
        "/document/#{p}/vDepth",
        "/document/#{p}/vDistanceAboveSurface",
        "/document/#{p}/vUnitofMeasure",
        "/document/#{p}/minElevationInMeters",
        "/document/#{p}/maxElevationInMeters",
        "/document/#{p}/minDepthInMeters",
        "/document/#{p}/maxDepthInMeters",
        "/document/#{p}/minDistanceAboveSurfaceInMeters",
        "/document/#{p}/maxDistanceAboveSurfaceInMeters",
        "/document/#{p}/vCoordSource",
        "/document/#{p}/vCoordSourceRefId",
        "/document/#{p}/placeOwnerGroupList/placeOwnerGroup/ownershipDateGroup/dateDisplayDate",
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
          "/document/#{p}/addrGroupList/addrGroup/addressMunicipality",
          "/document/#{p}/addrGroupList/addrGroup/addressStateOrProvince",
          "/document/#{p}/addrGroupList/addrGroup/addressCountry",
          "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/geoReferencedBy",
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
      context 'when shared auth/vocab' do
        let(:attributes) { get_attributes_by_row('publicart', 'place_authority.csv', 4) }
        let(:doc) { get_doc(publicartplace) }
        let(:record) { get_fixture('publicart_place_row4.xml') }
        [
          "/document/#{p}/addrGroupList/addrGroup/addressMunicipality",
          "/document/#{p}/addrGroupList/addrGroup/addressStateOrProvince",
          "/document/#{p}/addrGroupList/addrGroup/addressCountry",
          "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/geoReferencedBy",
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
    pa = 'places_publicart'
    context 'authority/vocabulary fields' do
      [
        "/document/#{pa}/placementTypes/placementType",
        "/document/#{pa}/publicArtPlaceTypes/publicArtPlaceType",
        "/document/#{pa}/placementEnvironment",
        "/document/#{pa}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup/owner",
        "/document/#{pa}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup/ownerType",
        "/document/#{pa}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup/ownershipNote",
        "/document/#{pa}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup/ownershipDateGroup/dateDisplayDate"
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
