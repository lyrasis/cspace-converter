module CollectionSpace
  module Converter
    module Core
      class CoreUseOfCollection < UseOfCollection
        ::CoreUseOfCollection = CollectionSpace::Converter::Core::CoreUseOfCollection
        def convert
          run do |xml|
            CoreUseOfCollection.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # TODO
        end
      end
    end
  end
end
