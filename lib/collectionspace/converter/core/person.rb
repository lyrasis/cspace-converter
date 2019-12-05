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
          CSXML.add xml, 'shortIdentifier', config[:identifier]
          CSXML.add_group_list xml, 'personTerm', [
            {
              "title" => attributes["title"],
              "initials" => attributes["initials"],
              "foreName" => attributes["forename"],
              "surName" => attributes["surname"],
              "nameAdditions" => attributes["nameadditions"],
              "middleName" => attributes["middlename"],
              "salutation" => attributes["salutation"],
              "termDisplayName" => attributes["termdisplayname"],
              "termLanguage" => CSXML::Helpers.get_vocab('languages', attributes["termlanguage"]),
              "termName" => attributes["termname"],
              "termPrefForLang" => attributes.fetch("termprefforlang", '').downcase,
              "termQualifier" => attributes["termqualifier"],
              "termSource" => CSXML::Helpers.get_vocab('citation', attributes["termsource"]),
              "termSourceID" => attributes["termsourceid"],
              "termSourceDetail" => attributes["termsourcedetail"],
              "termSourceNote" => attributes["termsourcenote"],
              "termStatus" => attributes["termstatus"],
              "termType" => CSXML::Helpers.get_vocab('persontermtype', attributes["termtype"]),
            }
          ]
          CSXML.add xml, 'birthPlace', attributes["birthplace"]
          CSXML::Helpers.add_date_group(
            xml, 'birthDate', CSDTP.parse(attributes['birthdategroup'])
          )
          CSXML::Helpers.add_date_group(
            xml, 'deathDate', CSDTP.parse(attributes['deathdategroup'])
          )
          CSXML.add xml, 'deathPlace', attributes["deathplace"]
          CSXML.add_repeat xml, 'groups', [{'group' => attributes['group']}]
          CSXML.add_repeat xml, 'nationalities', [{'nationality' => attributes['nationality']}]
          CSXML.add xml, 'gender', attributes["gender"]
          CSXML.add_repeat xml, 'occupations', [{'occupation' => attributes['occupation']}]
          CSXML.add_repeat xml, 'schoolsOrStyles', [{'schoolOrStyle' => attributes['schoolorstyle']}]
          CSXML.add xml, 'bioNote', attributes["bionote"]
          CSXML.add xml, 'nameNote', attributes["namenote"]
        end
      end
    end
  end
end
