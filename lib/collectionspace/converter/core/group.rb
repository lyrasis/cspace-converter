module CollectionSpace
  module Converter
    module Core
      class CoreGroup < Group
        ::CoreGroup = CollectionSpace::Converter::Core::CoreGroup
        def convert
          run do |xml|
            CoreGroup.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML::Helpers.add_persons xml, 'owner', [attributes["owner"]]
          CSXML.add xml, 'title', attributes["title"]
          CSXML.add xml, 'scopeNote', scrub_fields([attributes["scope_note"]])
        end
      end
    end
  end
end
