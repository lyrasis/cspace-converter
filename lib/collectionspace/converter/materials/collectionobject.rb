module CollectionSpace
  module Converter
    module Materials
      class MaterialsCollectionObject < CollectionObject
        ::MaterialsCollectionObject = CollectionSpace::Converter::Materials::MaterialsCollectionObject
        def convert
          run do |xml|
            CoreCollectionObject.map(xml, attributes.merge(redefined_fields))
            MaterialsCollectionObject.map(xml, attributes)
          end
        end

        def redefined_fields
          @redefined = [
            'redefinedfield'
          ]
          super
        end

        def self.map(xml, attributes)
          # TODO
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
            overall << { "handling" => handl, "handlingNote" => note[index]}
          end
          CSXML.add_group_list xml, "materialHandling", overall
        end
      end
    end
  end
end
