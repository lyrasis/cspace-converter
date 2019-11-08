module CollectionSpace
  module Converter
    module Core
      class CorePerson < Person
        ::CorePerson = CollectionSpace::Converter::Core::CorePerson
        def convert
          run do |xml|
            CorePerson.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["termdisplayname"])
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
              "termPrefForLang" => attributes["termprefforlang"],
            }
          ]
          CSXML.add xml, 'birthPlace', attributes["birthplace"]
          CSXML.add xml, 'deathPlace', attributes["deathplace"]
          CSXML.add_repeat xml, 'groups', [{'group' => attributes['group']}]
          CSXML.add_repeat xml, 'nationalities', [{'nationality' => attributes['nationality']}]
          CSXML.add xml, 'gender', attributes["gender"]
          CSXML.add_repeat xml, 'occupations', [{'occupation' => attributes['occupation']}]
          CSXML.add_repeat xml, 'schoolsOrStyles', [{'schoolOrStyle' => attributes['schoolorstyle']}]
          CSXML.add xml, 'bioNote', attributes["bionote"]
          CSXML.add xml, 'nameNote', attributes["namenote"]
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
              "addressCounty" => attributes["addresscounty"],
            }
          ]
        end
      end
    end
  end
end
