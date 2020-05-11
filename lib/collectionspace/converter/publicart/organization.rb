module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtOrganization < Organization
        ::PublicArtOrganization = CollectionSpace::Converter::PublicArt::PublicArtOrganization
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:organizations_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/organization',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtOrganization.map(xml, attributes, config)
            end

            xml.send(
                "ns2:contacts_common",
                "xmlns:ns2" => "http://collectionspace.org/services/contact",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              Contact.map(xml, attributes)
            end

            xml.send(
              'ns2:organizations_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/organization/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtOrganization.extension(xml, attributes)
            end
          end
        end


        def self.extension(xml, attributes)
          pairs = {
            'currentplace' => 'currentPlace'
          }
          pairs_transforms = {
            'currentplace' => {'authority' => ['placeauthorities', 'place']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
          #socialMediaGroupList, socialMediaGroup
          socialmedia_data = {
            "socialmediahandle" => "socialMediaHandle",
            "socialmediahandletype" => "socialMediaHandleType",
          }
          socialmedia_transforms = {
            'socialmediahandletype' => {'vocab' => 'socialmediatype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'socialMedia',
            socialmedia_data,
            socialmedia_transforms
          )
        end

        def self.map(xml, attributes, config)
          pairs = {
            'foundingplace' => 'foundingPlace'
          }
          pairs_transforms = {
            'foundingplace' => {'authority' => ['placeauthorities', 'place']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
          repeats = {
            'historynote' => ['historyNotes', 'historyNote'],
            'organizationrecordtype' => ['organizationRecordTypes', 'organizationRecordType']
          }
          repeats_transforms = {
            'organizationrecordtype' => {'vocab' => 'organizationtype'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeats_transforms)
          #foundingDateGroup
          CSXML::Helpers.add_date_group(xml, 'foundingDate', CSDTP.parse(attributes['foundingdate']))
          #dissolutionDateGroup
          CSXML::Helpers.add_date_group(xml, 'dissolutionDate', CSDTP.parse(attributes['dissolutiondate']))
          CSXML.add xml, 'shortIdentifier', config[:identifier]
          #orgTermGroupList, orgTermGroup
          orgterm_data = {
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
            "mainbodyname" => "mainBodyName",
            "additionstoname" => "additionsToName" 
	  }
          orgterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsource' => {'authority' => ['citationauthorities', 'citation']},
            'termflag' => {'vocab' => 'orgtermflag'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'orgTerm',
            orgterm_data,
            orgterm_transforms
          )
        end
      end
    end
  end
end
