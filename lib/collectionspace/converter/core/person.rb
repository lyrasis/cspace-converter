module CollectionSpace
  module Converter
    module Core
      class CorePerson < Person
        ::CorePerson = CollectionSpace::Converter::Core::CorePerson
        def convert
          run do |xml|
            CorePerson.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["termdisplayname"])
          CSXML.add_group_list xml, 'personTerm', [
            {
              "termDisplayName" => attributes["termdisplayname"],
              "termType" => CSXML::Helpers.get_vocab('persontermtype', attributes["termtype"]),
            }
          ]
        end
      end
    end
  end
end
