module CollectionSpace
  module Converter
    module Core
      include Default
      class CoreConcept < Concept
        ::CoreConcept = CollectionSpace::Converter::Core::CoreConcept
        def convert
          run do |xml|
            # TODO: implement
          end
        end
      end
    end
  end
end
