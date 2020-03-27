module CollectionSpace
  module Converter
    module Core
      class CoreCitation < Citation
        ::CoreCitation = CollectionSpace::Converter::Core::CoreCitation
        def convert
          run do |xml|
            CoreCitation.map(xml, attributes, config)
          end
        end

        def self.map(xml, attributes, config)
          pairs = {
            'citationnote' => 'citationNote'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
          CSXML.add xml, 'shortIdentifier', config[:identifier] 
          #citationTermGroupList, citationTermGroup
          citationterm_data = {
	    "termdisplayname" => "termDisplayName",
	    "termlanguage" => "termLanguage",
	    "termprefforlang" => "termPrefForLang",
	    "termsource" => "termSource",
	    "termsourceid" => "termSourceID",
	    "termsourcedetail" => "termSourceDetail",
	    "termsourcenote" => "termSourceNote",
 	    "termstatus" => "termStatus",
	    "termtype" => "termType",
            "termflag" => "termFlag",
            "termvolume" => "termVolume",
            "termfullcitation" => "termFullCitation",
            "termsubtitle" => "termSubTitle",
            "termsectiontitle" => "termSectionTitle",
            "termissue" => "termIssue",
            "termtitle" => "termTitle"
	  }
          citationterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsource' => {'authority' => ['citationauthorities', 'citation']},
            'termtype' => {'vocab' => 'citationtermtype'},
            'termflag' => {'vocab' => 'citationtermflag'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'citationTerm',
            citationterm_data,
            citationterm_transforms
          )
          #citationPublicationInfoGroupList, citationPublicationInfoGroup
          citationpublication_data = {
            "publicationplace" => "publicationPlace",
            "pages" => "pages",
            "publisher" => "publisher",
            "edition" => "edition",
            "publicationdate" => "publicationDate"
          }
          citationpublication_transforms = {
            'publicationdate' => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'citationPublicationInfo',
            citationpublication_data,
            citationpublication_transforms
          )
          #citationAgentInfoGroupList, citationAgentInfoGroup
          citationagent_data = {
            "agentorganization" => "agent",
            "agentperson" => "agent",
            "role" => "role",
            "note" => "note"
          }
          citationagent_transforms = {
            'agentorganization' => {'authority' => ['orgauthorities', 'organization']},
            'agentperson' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'citationAgentInfo',
            citationagent_data,
            citationagent_transforms
          )
          #citationResourceIdentGroupList, citationResourceIdentGroup
          citationresourceident_data = {
            "resourceident" => "resourceIdent",
            "capturedate" => "captureDate",
            "type" => "type",
            "note" => "note"
          }
          citationresourceident_transforms = {
            'type' => {'vocab' => 'resourceidtype'},
            'capturedate' => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'citationResourceIdent',
            citationresourceident_data,
            citationresourceident_transforms
          )
          #citationRelatedTermsGroupList, citationRelatedTermsGroup
          citationrelatedterms_data = {
            "relatedterm" => "relatedTerm",
            "relationtype" => "relationType"
          }
          citationrelatedterms_transforms = {
            'relatedterm' => {'authority' => ['conceptauthorities', 'concept']},
            'relationtype' => {'vocab' => 'relationtypetype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'citationRelatedTerms',
            citationrelatedterms_data,
            citationrelatedterms_transforms
          )
        end
      end
    end
  end
end
