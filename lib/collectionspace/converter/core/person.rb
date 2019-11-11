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
              CorePerson.contact(xml, attributes)
            end
          end
        end

        def self.map(xml, attributes, config)
          CSXML.add xml, 'shortIdentifier', config[:identifier]
          CSXML.add_group_list xml, 'personTerm', [
            {
              "termDisplayName" => attributes["termdisplayname"],
              #"termType" => CSXML::Helpers.get_vocab('persontermtype', attributes["termtype"]),
              "termSourceID" => attributes["termsourceid"],
              "termSourceDetail" => attributes["termsourcedetail"],
              "surName" => attributes["surname"],
              "termSourceNote" => attributes["termsourcenote"],
              "initials" => attributes["initials"],
              "title" => attributes["title"],
              "termSource" => CSXML::Helpers.get_vocab('citation', attributes["termsource"]),
              "foreName" => attributes["forename"],
              "nameAdditions" => attributes["nameadditions"],
              "termStatus" => attributes["termstatus"],
              "termLanguage" => CSXML::Helpers.get_vocab('languages', attributes["termlanguage"]),
              "middleName" => attributes["middlename"],
              "salutation" => attributes["salutation"],
              "termName" => attributes["termname"],
              "termQualifier" => attributes["termqualifier"],
              "termPrefForLang" => attributes.fetch("termprefforlang", '').downcase,
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

        def self.contact(xml, attributes)
          CSXML.add_group_list xml, 'email', [
            {
              "email" => attributes["email"],
              "emailType" => attributes["emailtype"],
            }
          ]
          CSXML.add_group_list xml, 'telephoneNumber', [
            {
              "telephoneNumber" => attributes["telephonenumber"],
              "telephoneNumberType" => attributes["telephonenumbertype"],
            }
          ]
          CSXML.add_group_list xml, 'faxNumber', [
            {
              "faxNumber" => attributes["faxnumber"],
              "faxNumberType" => attributes["faxnumbertype"],
            }
          ]
          CSXML.add_group_list xml, 'webAddress', [
            {
              "webAddress" => attributes["webaddress"],
              "webAddressType" => attributes["webaddresstype"],
            }
          ]
          CSXML.add_group_list xml, 'address', [
            {
              "addressType" => attributes["addresstype"],
              "addressPlace1" => attributes["addressplace1"],
              "addressPlace2" => attributes["addressplace2"],
              "addressMunicipality" => attributes["addressmunicipality"],
              "addressStateOrProvince" => attributes["addressstateorprovince"],
              "addressPostCode" => attributes["addresspostcode"],
              "addressCountry" => attributes["addresscountry"],
            }
          ]
        end
      end
    end
  end
end
