module CollectionSpace
  module Converter
    module Anthro
      class AnthroTaxon < Taxon
        ::AnthroTaxon = CollectionSpace::Converter::Anthro::AnthroTaxon
        def convert
          run do |xml|
            AnthroTaxon.map(xml, attributes, config)
          end
        end

        def self.map(xml, attributes, config)
          pairs = {
            'taxonrank' => 'taxonRank',
            'taxoncurrency' => 'taxonCurrency',
            'taxonyear' => 'taxonYear',
            'taxonisnamedhybrid' => 'taxonIsNamedHybrid',
            'taxonnote' => 'taxonNote' 
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
          repeats = {
            'taxoncitation' => ['taxonCitationList', 'taxonCitation']
          }
          repeats_transforms = {
            'taxoncitation' => {'authority' => ['citationauthorities', 'citation']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeats_transforms)
          #identifier
          CSXML.add xml, 'shortIdentifier', config[:identifier]
          #taxonTermGroupList, taxonTermGroup
          taxonterm_data = {
	    "termdisplayname" => "termDisplayName",
	    "termlanguage" => "termLanguage",
	    "termprefforlang" => "termPrefForLang",
	    "termqualifier" => "termQualifier",
	    "termsource" => "termSource",
	    "termsourceid" => "termSourceID",
	    "termsourcedetail" => "termSourceDetail",
	    "termsourcenote" => "termSourceNote",
 	    "termstatus" => "termStatus",
	    "termtype" => "termType",
            "termflag" => "termFlag",
            "termformatteddisplayname" => "termFormattedDisplayName",
            "taxonomicstatus" => "taxonomicStatus"
	  }
          taxonterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsource' => {'authority' => ['citationauthorities', 'citation']},
            'termflag' => {'vocab' => 'taxontermflag'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'taxonTerm',
            taxonterm_data,
            taxonterm_transforms
          )        
          #commonNameGroupList, commonNameGroup
          commonname_data = {
            "commonname" => "commonName",
            "commonnamelanguage" => "commonNameLanguage",
            "commonnamesourcedetail" => "commonNameSourceDetail",
            "commonnamesource" => "commonNameSource"
          }
          commonname_transforms = {
            'commonnamelanguage' => {'vocab' => 'languages'},
            'commonnamesource' => {'authority' => ['citationauthorities', 'citation']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'commonName',
            commonname_data,
            commonname_transforms
          )
          #taxonAuthorGroupList, taxonAuthorGroup
          taxonauthor_data = {
            "taxonauthor" => "taxonAuthor",
            "taxonauthortype" => "taxonAuthorType"
          }
          taxonauthor_transforms = {
            'taxonauthor' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'taxonAuthor',
            taxonauthor_data,
            taxonauthor_transforms
          )
        end
      end
    end
  end
end
