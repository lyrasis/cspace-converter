# frozen_string_literal: true

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
          CSXML.add xml, 'shortIdentifier', config[:identifier]
          CSXML.add_group_list xml, 'taxonTerm', [
            {
              'taxonomicStatus' => attributes['taxonomicstatus'],
              'termDisplayName' => attributes['termdisplayname'],
              'termFlag' => CSXML::Helpers.get_vocab('taxontermflag', attributes['termflag']),
              'termFormattedDisplayName' => attributes['termformatteddisplayname'],
              'termLanguage' => CSXML::Helpers.get_vocab('languages', attributes['termlanguage']),
              'termName' => attributes['termname'],
              'termPrefForLang' => attributes.fetch('termprefforlang', '').downcase,
              'termQualifier' => attributes['termqualifier'],
              'termSource' => CSXML::Helpers.get_vocab('citation', attributes['termsource']),
              'termSourceID' => attributes['termsourceid'],
              'termSourceDetail' => attributes['termsourcedetail'],
              'termSourceNote' => attributes['termsourcenote'],
              'termStatus' => attributes['termstatus'],
              'termType' => attributes['termtype']
            },
            {
              'termDisplayName' => attributes['additionaltermdisplayname'],
              'termStatus' => attributes['additionaltermstatus']
            }
          ]
          CSXML.add_group_list xml, 'commonName', [{
            'commonName' => attributes['commonname']
          }]
        end
      end
    end
  end
end
