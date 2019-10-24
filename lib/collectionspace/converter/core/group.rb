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
          CSXML::Helpers.add_person xml, 'owner', attributes["owner"]
          CSXML.add xml, 'title', attributes["title"]
          CSXML.add xml, 'scopeNote', scrub_fields([attributes["scopenote"]])
          CSXML.add xml, 'responsibleDepartment', attributes["responsibledepartment"]
          CSXML.add xml, 'groupLatestDate', CSDTP.parse(attributes['grouplatestdate']).earliest_scalar
          CSXML.add xml, 'groupEarliestSingleDate', CSDTP.parse(attributes['groupearliestsingledate']).earliest_scalar
        end
      end
    end
  end
end

