module CollectionSpace
  module Converter
    module Core
      class CoreConcept < Concept
        ::CoreConcept = CollectionSpace::Converter::Core::CoreConcept
        def convert
          run do |xml|
            CoreConcept.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # TODO
        end
      end
    end
  end
end
