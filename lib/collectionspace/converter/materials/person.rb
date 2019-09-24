module CollectionSpace
  module Converter
    module Materials
      include Default
      class MaterialsPerson < Person
        def convert
          run do |xml|
          	# Person Information
            CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["termdisplayname"])
            CSXML.add_group_list xml, 'personTerm', [
              {
                "termDisplayName" => attributes["termdisplayname"],
                "termType" => CSURN.get_vocab_urn('persontermtype', attributes["termtype"], true),
                "termName" => attributes["term_name"],
                "foreName" => attributes["fore_name"],
                "middleName" => attributes["middle_name"],
                "surName" => attributes["sur_name"],
                "initials" => attributes["initials"],
                "salutation" => attributes["salutation"],
                "title" => attributes["title"],
                "nameAdditions" => attributes["name_additions"],
                "termLanguage" => attributes["term_language"],
                "termPrefForLang" => attributes["term_pref_for_lang"],
                "termQualifier" => attributes["term_qualifier"],
                "termSource" => attributes["term_source"],
                "termSourceID" => attributes["term_source_id"],
                "termSourceDetail" => attributes["term_source_detail"],
                "termSourceNote" => attributes["term_source_note"],
                "termStatus" => attributes["term_status"],
              }
            ]
            #birthDateGroup
            CSXML.add_group xml, 'birthDate', { "birthDateGroup" => attributes['birth_date_group'],
              'dateAssociation' => attributes['date_association'],
              'dateEarliestSingleYear' => attributes['date_earliest_single_year'],
              'dateEarliestSingleMonth' => attributes['date_earliest_single_month'],
              'dateEarliestSingleDay' => attributes['date_earliest_single_day'],
              'dateEarliestSingleEra' => attributes['date_earliest_single_era'],
              'dateEarliestSingleCertainty' => attributes['date_earliest_single_certainty'],
              'dateEarliestSingleQualifier' => attributes['date_earliest_single_qualifier'],
              'dateEarliestSingleQualifierValue' => attributes['date_earliest_single_qualifier_value'],
              'DateEarliestSingleQualifierUnit' => attributes['date_earliest_single_qualifier_unit'],
              'dateLatestSingleYear' => attributes['date_latest_single_year'],
              'dateLatestSingleMonth' => attributes['date_latest_single_month'],
              'dateLatestSingleDay' => attributes['date_latest_single_day'],
              'dateLatestSingleEra' => attributes['date_latest_single_era'],
              'dateLatestSingleCertainty' => attributes['date_latest_single_certainty'],
              'dateLatestSingleQualifier' => attributes['date_latest_single_qualifier'],
              'dateLatestSingleQualifierValue' => attributes['date_latest_single_qualifier_value'],
              'DateLatestSingleQualifierUnit' => attributes['date_latest_single_qualifier_unit'],
              'datePeriod' => attributes['date_period'],
              'dateNote' => attributes['date_note'],
            }
            #deathDateGroup
            CSXML.add_group xml, 'birthDate', { "deathDateGroup" => attributes['death_date_group'],
              'dateAssociation' => attributes['date_association'],
              'dateEarliestSingleYear' => attributes['date_earliest_single_year'],
              'dateEarliestSingleMonth' => attributes['date_earliest_single_month'],
              'dateEarliestSingleDay' => attributes['date_earliest_single_day'],
              'dateEarliestSingleEra' => attributes['date_earliest_single_era'],
              'dateEarliestSingleCertainty' => attributes['date_earliest_single_certainty'],
              'dateEarliestSingleQualifier' => attributes['date_earliest_single_qualifier'],
              'dateEarliestSingleQualifierValue' => attributes['date_earliest_single_qualifier_value'],
              'DateEarliestSingleQualifierUnit' => attributes['date_earliest_single_qualifier_unit'],
              'dateLatestSingleYear' => attributes['date_latest_single_year'],
              'dateLatestSingleMonth' => attributes['date_latest_single_month'],
              'dateLatestSingleDay' => attributes['date_latest_single_day'],
              'dateLatestSingleEra' => attributes['date_latest_single_era'],
              'dateLatestSingleCertainty' => attributes['date_latest_single_certainty'],
              'dateLatestSingleQualifier' => attributes['date_latest_single_qualifier'],
              'dateLatestSingleQualifierValue' => attributes['date_latest_single_qualifier_value'],
              'DateLatestSingleQualifierUnit' => attributes['date_latest_single_qualifier_unit'],
              'datePeriod' => attributes['date_period'],
              'dateNote' => attributes['date_note'],
            }
            # birthPlace
            CSXML.add xml, 'birthPlace', attributes["birth_place"]
            # deathPlace
            CSXML.add xml, 'deathPlace', attributes["death_place"]
            # group
            CSXML.add xml, 'group', attributes["group"]
            # nationality
            CSXML.add xml, 'nationality', attributes["nationality"]
            # gender
            CSXML.add xml, 'gender', attributes["gender"]
            # occupation
            CSXML.add xml, 'occupation', attributes["occupation"]
            # schoolOrStyle
            CSXML.add xml, 'schoolOrStyle', attributes["school_or_style"]
            # bioNote
            CSXML.add xml, 'bioNote', attributes["bio_note"]
            # nameNote
            CSXML.add xml, 'nameNote', attributes["name_note"]
            # email
            CSXML.add xml, 'email', attributes["email"]
            CSXML.add xml, 'emailType', attributes["email_type"]
            # telephone
            CSXML.add xml, 'telephoneNumber', attributes["telephone_number"]
            CSXML.add xml, 'telephoneNumberType', attributes["telephone_number_type"]
            # fax
            CSXML.add xml, 'faxNumber', attributes["fax_number"]
            CSXML.add xml, 'faxNumberType', attributes["fax_number_type"]
            # WebAddress
            CSXML.add xml, 'webAddress', attributes["web_address"]
            CSXML.add xml, 'webAddressType', attributes["web_address_type"]
            # Address
            CSXML.add xml, 'addressType', attributes["address_type"]
            CSXML.add xml, 'addressPlace1', attributes["address_place1"]
            CSXML.add xml, 'addressPlace2', attributes["address_place2"]
            CSXML.add xml, 'addressMunicipality', attributes["address_municipality"]
            CSXML.add xml, 'addressStateOrProvince', attributes["address_state_or_province"]
            CSXML.add xml, 'addressPostCode', attributes["address_post_code"]
            CSXML.add xml, 'addressCounty', attributes["address_county"]
          end
        end
      end
    end
  end
end
