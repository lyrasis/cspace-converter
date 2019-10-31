module CollectionSpace
  module Converter
    module Core
      class CoreExhibition < Exhibition
        ::CoreExhibition = CollectionSpace::Converter::Core::CoreExhibition
        def convert
          run do |xml|
            CoreExhibition.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'exhibitionNumber', attributes["exhibition_number"]
          CSXML::Helpers.add_vocab xml, 'type', 'exhibitiontype', attributes["exhibition_type"]
          CSXML.add xml, 'title', attributes["exhibition_title"]
          CSXML.add_repeat xml, 'organizers', [{
            'organizer' =>  CSXML::Helpers.get_authority('orgauthorities', 'organization', attributes["organizer"])
          }]
          CSXML.add xml, 'boilerplateText', scrub_fields([attributes["boilerplate_text"]])
        end
      end
    end
  end
end
