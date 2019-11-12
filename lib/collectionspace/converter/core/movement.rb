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
          CSXML.add xml, 'movementReferenceNumber', attributes["movementreferencenumber"]
          CSXML::Helpers.add_location xml, 'normalLocation', attributes['normallocation']
          CSXML::Helpers.add_location xml, 'currentLocation', attributes['currentlocation']
          CSXML.add xml, 'currentLocationFitness', attributes["currentlocationfitness"]
          CSXML.add xml, 'currentLocationNote', attributes["currentlocationnote"]
          CSXML.add xml, 'locationDate', CSDTP.parse(attributes['locationdate']).earliest_scalar
          CSXML.add xml, 'reasonForMove', attributes["reasonformove"]
          CSXML::Helpers.add_person xml, 'movementContact', attributes["movementcontact"]
          CSXML.add_repeat xml, 'movementMethods', [{'movementMethod' => attributes['movementmethod']}]
          CSXML.add xml, 'plannedRemovalDate', CSDTP.parse(attributes['plannedremovaldate']).earliest_scalar
          CSXML.add xml, 'removalDate', CSDTP.parse(attributes['removaldate']).earliest_scalar
          CSXML.add xml, 'movementNote', attributes["movementnote"]
          CSXML.add xml, 'inventoryActionRequired', attributes["inventoryactionrequired"]
          CSXML.add xml, 'frequencyForInventory', attributes["frequencyforinventory"]
          CSXML.add xml, 'inventoryDate', CSDTP.parse(attributes['inventorydate']).earliest_scalar
          CSXML.add xml, 'nextInventoryDate', CSDTP.parse(attributes['nextinventorydate']).earliest_scalar
          CSXML.add_repeat xml, 'inventoryContact', [{'inventoryContact' => CSXML::Helpers.get_authority('personauthorities', 'person', attributes["inventorycontact"])}], 'List'
          CSXML.add xml, 'inventoryNote', attributes["inventorynote"]
        end
      end
    end
  end
end
