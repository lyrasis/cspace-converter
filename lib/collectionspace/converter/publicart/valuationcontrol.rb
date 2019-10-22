module CollectionSpace
  module Converter
    module PublicArt
      include Default
      class PublicArtValuationControl < ValuationControl
        ::PublicArtValuationControl = CollectionSpace::Converter::PublicArt::PublicArtValuationControl
        def convert
          run do |xml|
            CoreValuationControl.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
