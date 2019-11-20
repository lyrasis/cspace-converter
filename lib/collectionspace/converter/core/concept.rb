module CollectionSpace
  module Converter
    module Core
      class CoreConcept < Concept
        ::CoreConcept = CollectionSpace::Converter::Core::CoreConcept
        def convert
          run do |xml|
            CoreConcept.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)

          # conceptTermGroupList
           term_data = {
             'termSourceID' => attributes['termsourceid'],
             'termSourceNote' => attributes['termsourcenote'],
             'termDisplayName' => attributes['termdisplayname']
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
