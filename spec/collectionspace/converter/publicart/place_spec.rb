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
        context "#{xpath}" do
          it 'is empty' do
            verify_field_is_empty(doc, xpath)
          end
        end
      end
    end

    context 'fields overridden by publicart' do
      context 'authority/vocab fields' do
        [
          "/document/#{p}/addrGroupList/addrGroup/addressMunicipality",
          "/document/#{p}/addrGroupList/addrGroup/addressStateOrProvince",
          "/document/#{p}/addrGroupList/addrGroup/addressCountry",
          "/document/#{p}/placeGeoRefGroupList/placeGeoRefGroup/geoReferencedBy"
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
    pa = 'places_publicart'
    context 'non-authority/vocab fields' do
      [
        "/document/#{pa}/placementEnvironment",
        "/document/#{pa}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup/ownerType",
        "/document/#{pa}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup/ownershipNote",
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

    context 'structured dates' do
      [
        "/document/#{pa}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup/ownershipDateGroup"
      ].each do |xpath|
        context "#{xpath}" do
          let(:doctext) { get_structured_date(doc, xpath) }
            it 'is not empty' do
              expect(doc.xpath(xpath).size).to_not eq(0)
            end

            it 'matches sample payload' do
              expect(get_structured_date(doc, xpath)).to eq(get_structured_date(record, xpath))
            end
        end
      end
    end
    
    context 'authority/vocab fields' do
      [
        "/document/#{pa}/placementTypes/placementType",
        "/document/#{pa}/publicArtPlaceTypes/publicArtPlaceType",
        "/document/#{pa}/publicartPlaceOwnerGroupList/publicartPlaceOwnerGroup/owner"
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
