module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtPlace < Place
        ::PublicArtPlace = CollectionSpace::Converter::PublicArt::PublicArtPlace
        def redefined_fields
          @redefined.concat([
            'placetype',
            'placesource',
            'owner',
            'ownershipnote',
            'vcoordinates',
            'vlatitude',
            'vlongitude',
            'vcoordsys',
            'vspatialreferencesystem',
            'velevation',
            'vdepth',
            'vdistanceabovesurface',
            'vunitofmeasure',
            'minelevationinmeters',
            'maxelevationinmeters',
            'mindepthinmeters',
            'maxdepthinmeters',
            'mindistanceabovesurfaceinmeters',
            'maxdistanceabovesurfaceinmeters',
            'vcoordsource',
            'vcoordsourcerefid',
            'ownershipdategroup',
            # overridden by publicart
            'addressmunicipality',
            'addressstateorprovince',
            'addresscountry',
            'georeferencedby'
          ])
          super
        end

        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:places_common",
                "xmlns:ns2" => "http://collectionspace.org/services/place",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              PublicArtPlace.map_common(xml, attributes, config, redefined_fields)
            end

            xml.send(
              'ns2:places_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/place/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtPlace.map_publicart(xml, attributes)
            end

          end
        end


        def self.map_publicart(xml, attributes)
          pairs = {
            'placementenvironment' => 'placementEnvironment',
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
          repeats = {
            'publicartplacetype' => ['publicArtPlaceTypes', 'publicArtPlaceType'],
            'placementtype' => ['placementTypes', 'placementType']
          }
          repeat_transforms = {
            'publicartplacetype' => {'vocab' => 'placetypes'},
             'placementtype' => {'vocab' => 'placementtypes'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)
          #publicartPlaceOwnerGroupList, publicartPlaceOwnerGroup
          owner_data = {
            "publicartownerorganization" => "owner",
            "publicartownerperson" => "owner",
            "publicartownershipdategroup" => "ownershipDateGroup",
            "publicartownershipnote" => "ownershipNote",
            "publicartownertype" => "ownerType"
          }
          owner_transforms = {
            'publicartownerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'publicartownerperson' => {'authority' => ['personauthorities', 'person']},
            'publicartownershipdategroup' => {'special' => 'structured_date'},
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'publicartPlaceOwner',
            owner_data,
            owner_transforms
          )
        end
       
        def self.map_common(xml, attributes, config, redefined)
          CorePlace.map_common(xml, attributes.merge(redefined), config)
          #addrGroupList, addrGroup
          address_data = {
            "addresscountrylocal" => "addressCountry",
            "addresscountryshared" => "addressCountry",
            "addressmunicipalitylocal" => "addressMunicipality",
            "addressmunicipalityshared" => "addressMunicipality",
            "addressstateorprovincelocal" => "addressStateOrProvince",
            "addressstateorprovinceshared" => "addressStateOrProvince",
            "addresscounty" => "addressCounty",
            "addressplace2" => "addressPlace2",
            "addressplace1" => "addressPlace1",
            "addresstype" => "addressType",
            "addresspostcode" => "addressPostCode"
          }
          address_transforms = {
            'addresscountrylocal' => {'authority' => ['placeauthorities', 'place']},
            'addresscountryshared' => {'authority' => ['placeauthorities', 'place_shared']},
            'addressmunicipalitylocal' => {'authority' => ['placeauthorities', 'place']},
            'addressmunicipalityshared' => {'authority' => ['placeauthorities', 'place_shared']},
            'addressstateorprovincelocal' => {'authority' => ['placeauthorities', 'place']},
            'addressstateorprovinceshared' => {'authority' => ['placeauthorities', 'place_shared']},
            'addresscounty' => {'authority' => ['placeauthorities', 'place']},
            'addresstype' => {'vocab' => 'addresstype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'addr',
            address_data,
            address_transforms
          )
          #placeGeoRefGroupList, #placeGeoRefGroup
          placegeo_data = {
            'decimallatitude' => 'decimalLatitude',
            'decimallongitude' => 'decimalLongitude',
            'geodeticdatum' => 'geodeticDatum',
            'coorduncertaintyinmeters' => 'coordUncertaintyInMeters',
            'coordprecision' => 'coordPrecision',
            'pointradiusspatialfit' => 'pointRadiusSpatialFit',
            'footprintwkt' => 'footprintWKT',
            'footprintsrs' => 'footprintSRS',
            'footprintspatialfit' => 'footprintSpatialFit',
            'georeferencedbyorganization' => 'geoReferencedBy',
            'georefdategroup' => 'geoRefDateGroup',
            'georefprotocol' => 'geoRefProtocol',
            'georefsource' => 'geoRefSource',
            'georefverificationstatus' => 'geoRefVerificationStatus',
            'georefremarks' => 'geoRefRemarks',
            'georefplacename' => 'geoRefPlaceName',
            'georeferencedbyorganizationlocal' => 'geoReferencedBy',
            'georeferencedbyorganizationshared' => 'geoReferencedBy',
            'georeferencedbypersonlocal' => 'geoReferencedBy',
            'georeferencedbypersonshared' => 'geoReferencedBy',

          }
          placegeo_transforms = {
            'georeferencedbyorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'georeferencedbyorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']},
            'georeferencedbypersonlocal' => {'authority' => ['personauthorities', 'person']},
            'georeferencedbypersonshared' => {'authority' => ['personauthorities', 'person_shared']},
            'georefdategroup' => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'placeGeoRef',
            placegeo_data,
            placegeo_transforms
          )
        end

      end
    end
  end
end
