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
          concept_term_by_attr = {
            'termsourceid' => { :xmlfield => 'termSourceID' },
            'termsourcedetail' => { :xmlfield => 'termSourceDetail' },
            'termsourcenote' => { :xmlfield => 'termSourceNote' },
            'termformatteddisplayname' => { :xmlfield => 'termFormattedDisplayName' },
            'historicalstatus' => { :xmlfield => 'historicalStatus' },
            'termtype' => { :xmlfield => 'termType' },
            'termsource' => { :xmlfield => 'termSource' },
            'termstatus' => { :xmlfield => 'termStatus' },
            'termlanguage' => { :xmlfield => 'termLanguage' },
            'termname' => { :xmlfield => 'termName' },
            'termqualifier' => { :xmlfield => 'termQualifier' },
            'termprefforlang' => { :xmlfield => 'termPrefForLang' },
            'termdisplayname' => { :xmlfield => 'termDisplayName' },
            'termflag' => { :xmlfield => 'termFlag' }
          }

          tdata_by_attr = concept_term_by_attr.map { |attr, h | h[:vals] = split_mvf attributes, attr }
          #tdata_split = tdata_by_attr.each{ |attr, h| h[:svals] = h[
          

                    
          
          #CSXML.add_group_list xml, 'conceptTerm', [term_data]
          
          # materials = split_mvf attributes, 'material'
          # materials.each do |m|
          #   mgs << { "material" => m }
          # end
          # CSXML.add_group_list xml, 'material', mgs

          # CSXML.add xml, 'termDisplayName', attributes['termDisplayName']

          # CSXML.add_repeat xml, 'conceptRecordTypes', [{
          #   'conceptRecordType' => CSURN.get_vocab_urn('concepttype', attributes['conceptrecordtype'])
          # }] if attributes['conceptrecordtype']
          
          # CSXML.add xml, 'scopeNote', attributes['scopenote']
          # #termSourceID
          # #termSourceNote
        end
      end
    end
  end
end
