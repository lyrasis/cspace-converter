module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtPerson < Person
        ::PublicArtPerson = CollectionSpace::Converter::PublicArt::PublicArtPerson
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:persons_common",
                "xmlns:ns2" => "http://collectionspace.org/services/person",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              PublicArtPerson.map(xml, attributes, config)
            end

            xml.send(
              'ns2:persons_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/person/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtPerson.extension(xml, attributes)
            end

            xml.send(
                "ns2:contacts_common",
                "xmlns:ns2" => "http://collectionspace.org/services/contact",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              Contact.map(xml, attributes)
            end
          end
        end

        def self.map(xml, attributes, config)
          pairs = {
            'birthplace' => 'birthPlace',
            'deathplace' => 'deathPlace',
            'bionote' => 'bioNote'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)

          CSXML.add xml, 'shortIdentifier', config[:identifier]
          #personTermGroupList, personTermGroup
          personterm_data = {
            "title"  => "title", 
            "initials" => "initials",
            "forename" => "foreName",
            "surname" => "surName",
            "nameadditions" => "nameAdditions",
            "middlename" => "middleName",
            "salutation" => "salutation",
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
            "termdisplaynamenonpreferred" => "termFormattedDisplayName"
          }
          personterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsource' => {'vocab' => 'citation'},
            'termtype' => {'vocab' => 'persontermtype'},
            'termflag' => {'vocab' => 'persontermflag'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'personTerm',
            personterm_data,
            personterm_transforms
          )
          #birthDateGroup
          CSXML::Helpers.add_date_group(
            xml, 'birthDate', CSDTP.parse(attributes['birthdategroup'])
          )
          #deathDateGroup
          CSXML::Helpers.add_date_group(
            xml, 'deathDate', CSDTP.parse(attributes['deathdategroup'])
          )
        end
  
        def self.extension(xml, attributes)
          repeats = { 
            'organization' => ['organizations', 'organization']
          }
          repeats_transforms = {
            'organization' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeats_transforms)
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

      end
    end
  end
end
