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
          pairs = {
            'movementreferencenumber' => 'movementReferenceNumber',
            'normallocationstorage' => 'normalLocation',
            'normallocationorganization' => 'normalLocation',
            'currentlocationstorage' => 'currentLocation',
            'currentlocationorganization' => 'currentLocation',
            'currentlocationfitness' => 'currentLocationFitness',
            'currentlocationnote' => 'currentLocationNote',
            'locationdate' => 'locationDate',
            'reasonformove' => 'reasonForMove',
            'movementcontact' => 'movementContact',
            'plannedremovaldate' => 'plannedRemovalDate',
            'removaldate' => 'removalDate',
            'movementnote' => 'movementNote',
            'inventoryactionrequired' => 'inventoryActionRequired',
            'frequencyforinventory' => 'frequencyForInventory',
            'inventorydate' => 'inventoryDate',
            'nextinventorydate' => 'nextInventoryDate',
            'inventorynote' => 'inventoryNote'
          }
          pairstransforms = {
            'normallocationstorage' => {'authority' => ['locationauthorities', 'location']},
            'normallocationorganization' => {'authority' => ['orgauthorities', 'organization']},
            'currentlocationstorage' => {'authority' => ['locationauthorities', 'location']},
            'currentlocationorganization' => {'authority' => ['orgauthorities', 'organization']},
            'locationdate' => {'special' => 'unstructured_date_stamp'},
            'plannedremovaldate' => {'special' => 'unstructured_date_stamp'},
            'removaldate' => {'special' => 'unstructured_date_stamp'},
            'inventorydate' => {'special' => 'unstructured_date_stamp'},
            'nextinventorydate' => {'special' => 'unstructured_date_stamp'},
            'movementcontact' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          repeats = {
            'movementmethod' => ['movementMethods', 'movementMethod'],
            'inventorycontact' => ['inventoryContactList', 'inventoryContact'] 
          }
          repeatstransforms = {
            'inventorycontact' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
        end
      end
    end
  end
end
