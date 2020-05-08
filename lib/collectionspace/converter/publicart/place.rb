module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtPlace < Place
        ::PublicArtPlace = CollectionSpace::Converter::PublicArt::PublicArtPlace
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:places_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/place',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtPlace.map(xml, attributes)
            end

            xml.send(
              'ns2:places_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/place/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtPlace.extension(xml, attributes)
            end
          end
        end

        def self.extension(xml, attributes)
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
            "ownerorganization" => "owner",
            "ownerperson" => "owner",
            "ownershipdategroup" => "ownershipDateGroup",
            "ownershipnote" => "ownershipNote",
            "ownertype" => "ownerType"
          }
          owner_transforms = {
            'ownerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'ownerperson' => {'authority' => ['personauthorities', 'person']},
            'ownershipdategroup' => {'special' => 'structured_date'},
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'publicartPlaceOwner',
            owner_data,
            owner_transforms
          )
        end

        def self.map(xml, attributes)
          pairs = {
            'placenote' => 'placeNote',
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
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
          #addrGroupList, addrGroup
          address_data = {
            "addresscountry" => "addressCountry",
            "addresscounty" => "addressCounty",
            "addressplace2" => "addressPlace2",
            "addressplace1" => "addressPlace1",
            "addresstype" => "addressType",
            "addressmunicipality" => "addressMunicipality",
            "addresspostcode" => "addressPostCode",
            "addressstateorprovince" => "addressStateOrProvince",
          }
          address_transforms = {
            'addresscountry' => {'authority' => ['placeauthorities', 'place']},
            'addresscounty' => {'authority' => ['placeauthorities', 'place']},
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
