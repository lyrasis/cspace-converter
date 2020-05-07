module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtMovement < Movement
        ::PublicArtMovement = CollectionSpace::Converter::PublicArt::PublicArtMovement
        def convert
          run do |xml|
            PublicArtMovement.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          pairs = {
            'movementreferencenumber' => 'movementReferenceNumber',
            'currentlocationplace' => 'currentLocation',
            'currentlocationorganization' => 'currentLocation',
            'currentlocationstorage' => 'currentLocation',
            'currentlocationfitness' => 'currentLocationFitness',
            'currentlocationnote' => 'currentLocationNote',
            'locationdate' => 'locationDate',
            'reasonformove' => 'reasonForMove',
            'movementcontact' => 'movementContact',
            'movementnote' => 'movementNote',
            'plannedremovaldate' => 'plannedRemovalDate',
            'removaldate' => 'removalDate'
          }
          pairstransforms = {
            'currentlocationplace' => {'authority' => ['placeauthorities', 'place']},
            'currentlocationstorage' => {'authority' => ['locationauthorities', 'location']},
            'currentlocationorganization' => {'authority' => ['orgauthorities', 'organization']},
            'locationdate' => {'special' => 'unstructured_date_stamp'},
            'movementcontact' => {'authority' => ['personauthorities', 'person']},
            'removaldate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          repeats = {
            'movementmethod' => ['movementMethods', 'movementMethod'],

          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats)
        end
      end
    end
  end
end
