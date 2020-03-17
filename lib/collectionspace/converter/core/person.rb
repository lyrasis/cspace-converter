module CollectionSpace
  module Converter
    module Core
      class CorePerson < Person
        ::CorePerson = CollectionSpace::Converter::Core::CorePerson
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:persons_common",
                "xmlns:ns2" => "http://collectionspace.org/services/person",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              CorePerson.map(xml, attributes, config)
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
            'gender' => 'gender',
            'bionote' => 'bioNote',
            'namenote' => 'nameNote'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
    
          repeats = { 
            'group' => ['groups', 'group'],
            'nationality' => ['nationalities', 'nationality'],
            'occupation' => ['occupations', 'occupation'],
            'schoolorstyle' => ['schoolsOrStyles', 'schoolOrStyle'],
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats)


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
      end
    end
  end
end
