# frozen_string_literal: true

require_relative '../core/person'

module CollectionSpace
  module Converter
    module Anthro
      class AnthroPerson < CorePerson
        ::AnthroPerson = CollectionSpace::Converter::Anthro::AnthroPerson
        include Contact
        
        def initialize(attributes, config = {})
          super(attributes, config)
          @redefined = [
            'title' ,
            'initials',
            'forename',
            'surname',
            'nameadditions',
            'middlename',
            'salutation',
            'termdisplayname',
            'termlanguage',
            'termname',
            'termprefforlang',
            'termqualifier',
            'termsource',
            'termsourcelocal',
            'termsourceworldcat',
            'termsourceid',
            'termsourcedetail',
            'termsourcenote',
            'termstatus',
            'termtype',
            'termflag',
            'titlenonpreferred',
            'initialsnonpreferred',
            'forenamenonpreferred',
            'surnamenonpreferred',
            'nameadditionsnonpreferred',
            'middlenamenonpreferred',
            'salutationnonpreferred',
            'termdisplaynamenonpreferred',
            'termlanguagenonpreferred',
            'termnamenonpreferred',
            'termprefforlangnonpreferred',
            'termqualifiernonpreferred',
            'termsourcenonpreferred',
            'termsourcelocalnonpreferred',
            'termsourceworldcatnonpreferred',
            'termsourceidnonpreferred',
            'termsourcedetailnonpreferred',
            'termsourcenotenonpreferred',
            'termstatusnonpreferred',
            'termtypenonpreferred',
            'termflagnonpreferred',
          ]
        end

        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
                "ns2:persons_common",
                "xmlns:ns2" => "http://collectionspace.org/services/person",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              map_common(xml, attributes, config)
            end

            xml.send(
                "ns2:contacts_common",
                "xmlns:ns2" => "http://collectionspace.org/services/contact",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              map_contact(xml, attributes)
            end

            xml.send(
              'ns2:persons_anthro',
              'xmlns:ns2' => 'http://collectionspace.org/services/person/domain/anthro',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_anthro(xml, attributes)
            end
          end
        end

        def map_common(xml, attributes, config)
          super(xml, attributes.merge(redefined_fields), config)
          #personTermGroupList, personTermGroup
          personterm_data = {
            'title'  => 'title', 
            'initials' => 'initials',
            'forename' => 'foreName',
            'surname' => 'surName',
            'nameadditions' => 'nameAdditions',
            'middlename' => 'middleName',
            'salutation' => 'salutation',
            'termdisplayname' => 'termDisplayName',
            'termlanguage' => 'termLanguage',
            'termname' => 'termName',
            'termprefforlang' => 'termPrefForLang',
            'termqualifier' => 'termQualifier',
            'termsource' => 'termSource',
            'termsourcelocal' => 'termSource',
            'termsourceworldcat' => 'termSource',
            'termsourceid' => 'termSourceID',
            'termsourcedetail' => 'termSourceDetail',
            'termsourcenote' => 'termSourceNote',
            'termstatus' => 'termStatus',
            'termtype' => 'termType',
            'termflag' => 'termFlag',
            'titlenonpreferred' => 'title', 
            'initialsnonpreferred' => 'initials',
            'forenamenonpreferred' => 'foreName',
            'surnamenonpreferred' => 'surName',
            'nameadditionsnonpreferred' => 'nameAdditions',
            'middlenamenonpreferred' => 'middleName',
            'salutationnonpreferred' => 'salutation',
            'termdisplaynamenonpreferred' => 'termDisplayName',
            'termlanguagenonpreferred' => 'termLanguage',
            'termnamenonpreferred' => 'termName',
            'termprefforlangnonpreferred' => 'termPrefForLang',
            'termqualifiernonpreferred' => 'termQualifier',
            'termsourcenonpreferred' => 'termSource',
            'termsourcelocalnonpreferred' => 'termSource',
            'termsourceworldcatnonpreferred' => 'termSource',
            'termsourceidnonpreferred' => 'termSourceID',
            'termsourcedetailnonpreferred' => 'termSourceDetail',
            'termsourcenotenonpreferred' => 'termSourceNote',
            'termstatusnonpreferred' => 'termStatus',
            'termtypenonpreferred' => 'termType',
            'termflagnonpreferred' => 'termFlag'
          }
          personterm_transforms = {
            'termlanguage' => {'vocab' => 'languages'},
            'termsource' => {'authority' => ['citationauthorities', 'citation']},
            'termsourcelocal' => {'authority' => ['citationauthorities', 'citation']},
            'termsourceworldcat' => {'authority' => ['citationauthorities', 'worldcat']},
            'termflag' => {'vocab' => 'persontermflag'},
            'termlanguagenonpreferred' => {'vocab' => 'languages'},
            'termsourcenonpreferred' => {'authority' => ['citationauthorities', 'citation']},
            'termsourcelocalnonpreferred' => {'authority' => ['citationauthorities', 'citation']},
            'termsourceworldcatnonpreferred' => {'authority' => ['citationauthorities', 'worldcat']},
            'termflagnonpreferred' => {'vocab' => 'persontermflag'}
          }
            
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'personTerm',
            personterm_data,
            personterm_transforms
          )
        end

        def map_anthro(xml, attributes)
          repeats = {
            'personrecordtype' => ['personRecordTypes', 'personRecordType']
          }
          repeats_transforms = {
            'personrecordtype' => {'vocab' => 'persontermtype'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeats_transforms)

        end
      end
    end
  end
end
