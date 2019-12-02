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
              CoreCollectionObject.map(xml, attributes.merge(redefined_fields))
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
          @redefined = [
            'redefinedfield'
          ]
          super
        end

        def self.map(xml, attributes)
          CSXML.add_group_list xml, "materialCondition", [{
            "conditionNote" => attributes["conditionnote"],
            "condition" => CSXML::Helpers.get_vocab('materialcondition', attributes["condition"])
          }]
          CSXML.add_group_list xml, "materialContainer", [{
            "containerNote" => attributes["containernote"],
            "container" => CSXML::Helpers.get_vocab('materialcontainer', attributes["container"])
          }]
          overall = []
          handling = CSDR.split_mvf attributes, 'handling'
          note = CSDR.split_mvf attributes, 'handlingnote'
          handling.each_with_index do |handl, index|
            overall << { "handling" => CSXML::Helpers.get_vocab('materialhandling', handl), "handlingNote" => note[index]}
          end
          CSXML.add_group_list xml, "materialHandling", overall
          CSXML.add_group_list xml, "materialFinish", [{
            "finishNote" => attributes["finishnote"],
            "finish" => CSXML::Helpers.get_vocab('materialfinish', attributes["finish"])
          }]
          CSXML.add_repeat xml, 'materialGenericColors', [{
            "materialGenericColor" => CSXML::Helpers.get_vocab('materialgenericcolor', attributes["materialgenericcolor"])
          }]
          CSXML.add_repeat xml, 'materialPhysicalDescriptions', [{
            "materialPhysicalDescription" => attributes["physicaldescription"]
          }]

        end
      end
    end
  end
end
