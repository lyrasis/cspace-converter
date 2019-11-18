module CollectionSpace
  module Converter
    module Materials
      class MaterialsCollectionObject < CollectionObject
        ::MaterialsCollectionObject = CollectionSpace::Converter::Materials::MaterialsCollectionObject
        def convert
          run do |xml|
            CoreCollectionsObject.map(xml, attributes.merge(redefined_fields))
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
          CSXML.add xml, 'objectNumber', attributes["objectnumber"]
        end
      end
    end
  end
end
