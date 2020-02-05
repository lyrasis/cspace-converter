module CollectionSpace
  module Converter
    module PublicArt
      COMMON_ERA_URN = "urn:cspace:publicart.collectionspace.org:vocabularies:name(dateera):item:name(ce)'CE'"
      class PublicArtCollectionObject < CollectionObject
        ::PublicArtCollectionObject = CollectionSpace::Converter::PublicArt::PublicArtCollectionObject
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:collectionobjects_common",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              CoreCollectionObject.map(xml, attributes.merge(redefined_fields))
              PublicArtCollectionObject.map_common_overrides(xml, attributes)
            end

            #
            # Public Art extension fields
            #
            xml.send(
              "ns2:collectionobjects_publicart",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/local/publicart",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              PublicArtCollectionObject.map(xml, attributes)
            end
          end #run(wrapper: "document") do |xml|
        end #def convert

        def redefined_fields
          @redefined = [
            'responsibledepartment',
            'objectname',
            'objectnamenote',
            'material',
            'materialcomponentnote'
          ]
          super
        end

        def self.map_common_overrides(xml, attributes)
          repeats = {
            'responsibledepartment' => ['responsibleDepartments', 'responsibleDepartment']
          }
          repeat_transforms = {
            'responsibledepartment' => {'vocab' => 'program'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)

          oname_data = {
            'objectname' => 'objectName',
            'objectnamenote' => 'objectNameNote'
          }
          oname_transforms = {
            'objectname' => {'authority' => ['conceptauthorities', 'worktype']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'objectName',
            oname_data,
            oname_transforms,
            list_suffix: 'List'
          )

          mat_data = {
            'material' => 'material',
            'materialcomponentnote' => 'materialComponentNote'
          }
          mat_transforms = {
            'material' => {'authority' => ['conceptauthorities', 'material_ca']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'material',
            mat_data,
            mat_transforms
          )
        end

        def self.map(xml, attributes)
          repeats = {
            'publicartcollection' => ['publicartCollections', 'publicartCollection']
          }
          repeat_transforms = {
            'publicartcollection' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)

          ppd_data = {
            'publicartproductiondate' => 'publicartProductionDate',
            'publicartproductiondatetype' => 'publicartProductionDateType'
          }
          ppd_transforms = {
            'publicartproductiondate' => {'special' => 'structured_date'},
            'publicartproductiondatetype' => {'vocab' => 'proddatetype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'publicartProductionDate',
            ppd_data,
            ppd_transforms
          )
          ppp_data = {
            'publicartproductionpersontype' => 'publicartProductionPersonType',
            'publicartproductionpersonrole' => 'publicartProductionPersonRole',
            'publicartproductionpersonperson' => 'publicartProductionPerson',
            'publicartproductionpersonorganization' => 'publicartProductionPerson'
          }
          ppp_transforms = {
            'publicartproductionpersonrole' => {'vocab' => 'prodpersonrole'},
            'publicartproductionpersonperson' => {'authority' => ['personauthorities', 'person']},
            'publicartproductionpersonorganization' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'publicartProductionPerson',
            ppp_data,
            ppp_transforms
          )
        end # def self.map
      end # class PublicArtCollectionObject
    end #module PublicArt
  end # module Converter
end # module CollectionSpace
