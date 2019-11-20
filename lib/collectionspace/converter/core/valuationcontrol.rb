module CollectionSpace
  module Converter
    module Core
      class CoreValuationControl < ValuationControl
        ::CoreValuationControl = CollectionSpace::Converter::Core::CoreValuationControl
        def convert
          run do |xml|
            CoreValuationControl.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # TODO
        end
      end
    end
  end
end
