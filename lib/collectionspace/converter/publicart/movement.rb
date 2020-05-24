module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtMovement < Movement
        ::PublicArtMovement = CollectionSpace::Converter::PublicArt::PublicArtMovement
         def redefined_fields
          @redefined.concat([
            # not in publicart
            'normallocation',
            'inventoryactionrequired',
            'frequencyforinventory',
            'inventorydate',
            'nextInventorydate',
            'inventorycontact',
            'inventorynote',
            # overridden by publicart
            'currentlocation',
            'movementcontact'
          ])
          super
        end

        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:movements_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/movement',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtMovement.map_common(xml, attributes, redefined_fields)
            end

          end
        end


        def self.map_common(xml, attributes, redefined)
          CoreMovement.map_common(xml, attributes.merge(redefined))
          pairs = {
            'currentlocationstoragelocal' => 'currentLocation',
            'currentlocationorganizationlocal' => 'currentLocation',
            'currentlocationplacelocal' => 'currentLocation',
            'currentlocationstorageoffsite' => 'currentLocation',
            'currentlocationorganizationshared' => 'currentLocation',
            'currentlocationplaceshared' => 'currentLocation',
            'movementcontactlocal' => 'movementContact',
            'movementcontactshared' => 'movementContact'
          }
          pairs_transforms = {
            'currentlocationstoragelocal' => {'authority' => ['locationauthorities', 'location']},
            'currentlocationorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'currentlocationplacelocal' => {'authority' => ['placeauthorities', 'place']},
            'currentlocationstorageoffsite' => {'authority' => ['locationauthorities', 'offsite_sla']},
            'currentlocationorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']},
            'currentlocationplaceshared' => {'authority' => ['placeauthorities', 'place_shared']},
            'movementcontactlocal' => {'authority' => ['personauthorities', 'person']},
            'movementcontactshared' => {'authority' => ['personauthorities', 'person_shared']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
        end
      end
    end
  end
end
