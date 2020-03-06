module CollectionSpace
  module Converter
    module Core
      class CoreLocation < Location
        ::CoreLocation = CollectionSpace::Converter::Core::CoreLocation
        def convert
          run do |xml|
            CoreLocation.map(xml, attributes, config)
          end
        end

        def self.map(xml, attributes, config)
          pairs = {
            'locationtype' => 'locationType',
            'accessnote' => 'accessNote',
            'address' => 'address',
            'securitynote' => 'securityNote'
          }
          pairstransforms = {
            'locationtype' => {'vocab' => 'locationtype'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          CSXML.add xml, 'shortIdentifier', config[:identifier] 
          #locTermGroupList, locTermGroup
          locterm_data = {
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
            "termdisplaynamenonpreferred" => "termDisplayName"
	  }
          locterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsource' => {'authority' => ['citationauthorities', 'citation']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'locTerm',
            locterm_data,
            locterm_transforms
          )
          #conditionGroupList, conditionGroup
          condition_data = {
            "conditionnote" => "conditionNote",
            "conditionnotedate" => "conditionNoteDate",
          }
          condition_transforms = {
            'conditionnotedate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'condition',
            condition_data,
            condition_transforms
          )
        end
      end
    end
  end
end
