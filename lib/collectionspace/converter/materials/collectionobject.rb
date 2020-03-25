module CollectionSpace
  module Converter
    module Materials
      class MaterialsCollectionObject < CollectionObject
        ::MaterialsCollectionObject = CollectionSpace::Converter::Materials::MaterialsCollectionObject
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:collectionobjects_common",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              CoreCollectionObject.map_common(xml, attributes.merge(redefined_fields))
            end

            xml.send(
                "ns2:collectionobjects_materials",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/local/materials",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              MaterialsCollectionObject.map(xml, attributes)
            end
          end
        end

        def redefined_fields
          @redefined.concat(['redefinedfield'])
          super
        end

        def self.map(xml, attributes)
          repeats = {
              'materialgenericcolor' => ['materialGenericColors', 'materialGenericColor'],
              'materialphysicaldescription' => ['materialPhysicalDescriptions', 'materialPhysicalDescription']
            }
          repeatstransforms = {
            'materialgenericcolor' => {'vocab' => 'materialgenericcolor'},
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          materialconditiondata = {
            'conditionnote' => 'conditionNote',
            'condition' => 'condition'
          }
          materialconditiontransforms = {
            'condition' => {'vocab' => 'materialcondition'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'materialCondition',
            materialconditiondata,
            materialconditiontransforms
          )
          materialcontainerdata = {
            'containernote' => 'containerNote',
            'container' => 'container'
          }
          materialcontainertransforms = {
            'container' => {'vocab' => 'materialcontainer'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'materialContainer',
            materialcontainerdata,
            materialcontainertransforms
          )
          materialhandlingdata = {
            'handling' => 'handling',
            'handlingnote' => 'handlingNote'
          }
          materialhandlingtransforms = {
            'handling' => {'vocab' => 'materialhandling'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'materialHandling',
            materialhandlingdata,
            materialhandlingtransforms
          )
          materialfinishdata = {
            'finishnote' => 'finishNote',
            'finish' => 'finish'
          }
          materialfinishtransforms = {
            'finish' => {'vocab' => 'materialfinish'}
          } 
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'materialFinish',
            materialfinishdata,
            materialfinishtransforms
          )    
        end
      end
    end
  end
end
