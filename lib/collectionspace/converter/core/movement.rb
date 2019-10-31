module CollectionSpace
  module Converter
    module Core
      class CoreMovement < Movement
        ::CoreMovement = CollectionSpace::Converter::Core::CoreMovement
        def convert
          run do |xml|
            CoreMovement.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'movementReferenceNumber', attributes["inventory_reference_number"]
          CSXML::Helpers.add_location xml, 'currentLocation', attributes['current_location']
          CSXML.add xml, 'locationDate', attributes["location_date"]
          CSXML::Helpers.add_persons xml, 'borrowersAuthorizer', [attributes["movement_contact"]]
          CSXML.add xml, 'reasonForMove', attributes["reason_for_move"]
          CSXML.add xml, 'movementNote', scrub_fields([attributes["movement_information_note"]])
        end
      end
    end
  end
end
