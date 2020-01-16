module CollectionSpace
  module Converter
    module Core
      class CoreConcept < Concept
        ::CoreConcept = CollectionSpace::Converter::Core::CoreConcept
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:concepts_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/concept',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              CoreConcept.map(xml, attributes, config)
            end            
          end
        end

        def self.map(xml, attributes, config)
          CSXML.add xml, 'shortIdentifier', config[:identifier]

          # conceptTermGroupList
          term_data = {
            'termdisplayname' => 'termDisplayName',
            'termname' => 'termName',
            'termqualifier' => 'termQualifier',
            'termstatus' => 'termStatus',
            'termtype' => 'termType',
            'termflag' => 'termFlag',
            'historicalstatus' => 'historicalStatus',
            'termlanguage' => 'termLanguage',
            'termprefforlang' => 'termPrefForLang',
            'termsource' => 'termSource',
            'termsourcedetail' => 'termSourceDetail',
            'termsourceid' => 'termSourceID',
            'termsourcenote' => 'termSourceNote'
          }
          term_transforms = {
            'termsource' => {'authority' => ['citationauthorities', 'citation']},
            'termflag' => {'vocab' => 'concepttermflag'},
            'termlanguage' => {'vocab' => 'languages'},
            'termprefforlang' => {'special' => 'boolean'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'conceptTerm',
            term_data,
            term_transforms
            )


          CSXML.add_repeat xml, 'conceptRecordTypes', [{
            'conceptRecordType' => CSURN.get_vocab_urn('concepttype', attributes['conceptrecordtype'])
          }] if attributes['conceptrecordtype']
          
          CSXML.add xml, 'scopeNote', attributes['scopenote']
        end
      end
    end
  end
end
