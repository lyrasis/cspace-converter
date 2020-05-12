module CollectionSpace
  module Converter
    module Lhmc
      class LhmcCollectionObject < CollectionObject
        ::LhmcCollectionObject = CollectionSpace::Converter::Lhmc::LhmcCollectionObject


        # List all fields that will be overridden or removed here.

        # IMPORTANT: If the field to be overridden is part of a grouping of fields (repeats or group list),
        #   you need to list ALL the fields that are part of the group, and completely redefine the group
        #   here. Otherwise, you will get the value of each field not listed twice.

        # Listing a field here, but not redefining it will remove it from the new module.

        # @redefined is an Array of fieldname values. We add fields to it.

        # Then super calls the redefined_fields method definition from Default::Record, which
        #   returns a Hash where each key is an element of @redefined and all values are nil

        # Later, we call the CoreCollectionObject and CulturalCareCollectionObject's .map_* methods.
        #  Instead of sending the actual attributes from the CSV in those calls, we merge this
        #  redefined_fields hash in with the real attributes hash, which replaces any existing data
        #  in the listed fields with nil. 
        def redefined_fields
          @redefined.concat([
            'numbertype',
            'numbervalue',
            'contentplace',
            'inscriptioncontenttype',
            'inscriptioncontentmethod',
            'objectproductionplace',
            'assocplace',
            'ownershipplace',
            'contentscript'
          ])
          super
        end

        # convert is used to build the XML document, including the elements which group fields from
        #  different namespaces.

        # All the detailed logic for how individual fields are to be handled is defined below convert.

        # It seems sub-optimal to have to include the namespace and namespace declaration data
        #  explicitly every time we call in the logic from another module. However, this is necessary
        #  for now because even though assocplace is overridden by lhmc, it still needs to
        #  appear as a child of the common namespace.

        # NOTE:
        # The namespace for the core module is "common" because the "core" namespace is used for fields
        #  used across the CSpace application (like record created and updated timestamps). So, that's
        #  confusing... 
        def convert
          run(wrapper: "document") do |xml|
            # The xml.send wraps all fields in the <collectionobjects_common> element and defines
            #  the namespace attributes
            xml.send(
                "ns2:collectionobjects_common",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              # NOTE that we are calling the map_common method of LhmcCollectionObject!
              #  This calls CoreCollectionObject.map_common (with overridden fields removed)
              #  to populate all non-overridden fields AND defines the logic for any overridden fields
              LhmcCollectionObject.map_common(xml, attributes, redefined_fields)
            end

            xml.send(
              "ns2:collectionobjects_culturalcare",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/culturalcare",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              # Follows the same pattern as above. Note that we are not overriding any culturalcare
              #  fields at this time, but we follow the same pattern a) for consistency; and
              #  b) to make it easy to ever override a culturalcare field
              LhmcCollectionObject.map_cultural_care(xml, attributes, redefined_fields)
            end

            xml.send(
                "ns2:collectionobjects_lhmc",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/lhmc",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              # The map_lhmc method defines conversion logic for fields defined in the lhmc data
              #   profile
              # This logic cannot override itself, so we don't send the redefined_fields!
              LhmcCollectionObject.map_lhmc(xml, attributes)
            end

          end
        end

        # CORE
        def self.map_common(xml, attributes, redefined)
          # map non-overridden fields according to core logic
          CoreCollectionObject.map_common(xml, attributes.merge(redefined))

          # OVERRIDES
          pairs = {
            'ownershipplacelocal' => 'ownershipPlace',
            'ownershipplacetgn' => 'ownershipPlace'
          }
          pairs_transforms = {
            'ownershipplacelocal' => {'authority' => ['placeauthorities', 'place']},
            'ownershipplacetgn' => {'authority' => ['placeauthorities', 'tgn_place']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
          
          repeats = {
            'contentplacelocal' => ['contentPlaces', 'contentPlace'],
            'contentplacetgn' => ['contentPlaces', 'contentPlace']
          }
          repeats_transforms = {
            'contentplacelocal' => {'authority' => ['placeauthorities', 'place']},
            'contentplacetgn' => {'authority' => ['placeauthorities', 'tgn_place']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeats_transforms)
          
          #otherNumberList, otherNumber
          othernumber_data = {
            'numbervalue' => 'numberValue',
            'numbertype' => 'numberType'
          }
          othernumber_transforms = {
            'numbertype' => {'vocab' => 'numbertype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'otherNumber',
            othernumber_data,
            othernumber_transforms,
            list_suffix: 'List',
            group_suffix: ''
          )

          opp_data = {
            'objectproductionplacelocal' => 'objectProductionPlace',
            'objectproductionplacetgn' => 'objectProductionPlace',
            'objectproductionrole' => 'objectProductionRole'
          }
          opp_transforms = {
            'objectproductionplacelocal' => {'authority' => ['placeauthorities', 'place']},
            'objectproductionplacetgn' => {'authority' => ['placeauthorities', 'tgn_place']},
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPlace',
            opp_data,
            opp_transforms,
            list_suffix: 'GroupList',
            group_suffix: 'Group'
          )

        assoc_data = {
          'assocplacelocal' => 'assocPlace',
          'assocplacetgn' => 'assocPlace',
          'assocrole' => 'assocRole'
        }
        assoc_transforms = {
          'assocplacelocal' => {'authority' => ['placeauthorities', 'place']},
          'assocplacetgn' => {'authority' => ['placeauthorities', 'tgn_place']},
        }
        CSXML.add_single_level_group_list(
          xml,
          attributes,
          'assocPlace',
          assoc_data,
          assoc_transforms,
          list_suffix: 'GroupList',
          group_suffix: 'Group'
        )
        end
        # PROFILE
        def self.map_lhmc(xml, attributes)
          # no fields are added except for those from cultural care extension
        end

        # EXTENSIONS
        def self.map_cultural_care(xml, attributes, redefined)
          Extension.map_cultural_care(xml, attributes.merge(redefined))
        end

        
      end #class LhmcCollectionObject
    end #module Lhmc
  end #module Converter
end #module CollectionSpace
