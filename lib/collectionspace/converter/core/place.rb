module CollectionSpace
  module Converter
    module Core
      class CorePlace < Place
        ::CorePlace = CollectionSpace::Converter::Core::CorePlace
        def convert
          run do |xml|
            CorePlace.map(xml, attributes, config)
          end
        end

        def self.map(xml, attributes, config)
          pairs = {
            'placetype' => 'placeType',
            'placenote' => 'placeNote',
            'placesource' => 'placeSource',
            'vcoordinates' => 'vCoordinates',
            'vlatitude' => 'vLatitude',
            'vlongitude' => 'vLongitude',
            'vcoordsys' => 'vCoordSys',
            'vspatialreferencesystem' => 'vSpatialReferenceSystem', 
            'vcoordsource' => 'vCoordSource', 
            'vcoordsourcerefid' => 'vCoordSourceRefId',
            'vunitofmeasure' => 'vUnitofMeasure',
            'velevation' => 'vElevation',
            'minelevationinmeters' => 'minElevationInMeters',
            'maxelevationinmeters' => 'maxElevationInMeters',
            'vdepth' => 'vDepth',
            'mindepthinmeters' => 'minDepthInMeters',
            'maxdepthinmeters' => 'maxDepthInMeters',
            'vdistanceabovesurface' => 'vDistanceAboveSurface',
            'mindistanceabovesurfaceinmeters' => 'minDistanceAboveSurfaceInMeters',
            'maxdistanceabovesurfaceinmeters' => 'maxDistanceAboveSurfaceInMeters'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
          CSXML.add xml, 'shortIdentifier', config[:identifier] 
          #placeTermGroupList, placeTermGroup
          placeterm_data = {
	    "termdisplayname" => "termDisplayName",
	    "termlanguage" => "termLanguage",
	    "termname" => "termName",
	    "termprefforlang" => "termPrefForLang",
	    "termqualifier" => "termQualifier",
	    "termsource" => "termSource",
	    "termsourceid" => "termSourceID",
	    "termsourcedetail" => "termSourceDetail",
	    "termsourcenote" => "termSourceNote",
 	    "termstatus" => "termStatus",
	    "termtype" => "termType",
            "termflag" => "termFlag",
            "termdisplaynamenonpreferred" => "termFormattedDisplayName",
            "namedategroup" => "nameDateGroup",
            "historicalstatus" => "historicalStatus",
            "namenote" => "nameNote",
            "nameabbrev" => "nameAbbrev" 
	  }
          placeterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsource' => {'authority' => ['citationauthorities', 'citation']},
            'namedategroup' => {'special' => 'structured_date'},
            'termflag' => {'vocab' => 'placetermflag'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'placeTerm',
            placeterm_data,
            placeterm_transforms
          )
          #placeOwnerGroupList, placeOwnerGroup
          owner_data = {
            "ownerorganization" => "owner",
            "ownerperson" => "owner",
            "ownershipdategroup" => "ownershipDateGroup",
            "ownershipnote" => "ownershipNote"
          }
          owner_transforms = {
            'ownerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'ownerperson' => {'authority' => ['personauthorities', 'person']},
            'ownershipdategroup' => {'special' => 'structured_date'},
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'placeOwner',
            owner_data,
            owner_transforms
          )
          #addrGroupList, addrGroup
          address_data = {
            "addresscountry" => "addressCountry",
            "addressplace2" => "addressPlace2",
            "addressplace1" => "addressPlace1",
            "addresstype" => "addressType",
            "addressmunicipality" => "addressMunicipality",
            "addresspostcode" => "addressPostCode",
            "addressstateorprovince" => "addressStateOrProvince",
          }
          address_transforms = {
            'addresscountry' => {'authority' => ['placeauthorities', 'place']},
            'addresstype' => {'vocab' => 'addresstype'},
            'addressmunicipality' => {'authority' => ['placeauthorities', 'place']},
            'addressstateorprovince' => {'authority' => ['placeauthorities', 'place']}
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
            'georeferencedbyperson' => 'geoReferencedBy',
            'georefdategroup' => 'geoRefDateGroup',
            'georefprotocol' => 'geoRefProtocol',
            'georefsource' => 'geoRefSource',
            'georefverificationstatus' => 'geoRefVerificationStatus',
            'georefremarks' => 'geoRefRemarks',
            'georefplacename' => 'geoRefPlaceName' 

          }
          placegeo_transforms = {
            'georeferencedbyorganization' => {'authority' => ['orgauthorities', 'organization']},
            'georeferencedbyperson' => {'authority' => ['personauthorities', 'person']},
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
