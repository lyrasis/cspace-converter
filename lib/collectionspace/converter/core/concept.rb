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
            'historicalStatus' => attributes['historicalstatus'],
            'termDisplayName' => attributes['termdisplayname'],
            'termLanguage' => CSXML::Helpers.get_vocab('languages', attributes['termlanguage']),
            'termPrefForLang' => attributes['termprefforlang'],
            'termSource' => CSXML::Helpers.get_authority(
              'citationauthorities',
              'citation',
              attributes['termsource']
            ),
            'termSourceID' => attributes['termsourceid'],
            'termSourceNote' => attributes['termsourcenote'],
            'termStatus' => attributes['termstatus'],
            'termType' => attributes['termtype']
          }
          CSXML.add_group_list xml, 'conceptTerm', [term_data]

          CSXML.add xml, 'termDisplayName', attributes['termDisplayName']

          CSXML.add_repeat xml, 'conceptRecordTypes', [{
            'conceptRecordType' => CSURN.get_vocab_urn('concepttype', attributes['conceptrecordtype'])
          }] if attributes['conceptrecordtype']
          
          CSXML.add xml, 'scopeNote', attributes['scopenote']
        end
      end
    end
  end
end
