module CollectionSpace
  module Converter
    module PublicArt
      include Default
      class PublicArtExhibition < Exhibition
        ::PublicArtExhibition = CollectionSpace::Converter::PublicArt::PublicArtExhibition
        def convert
          run do |xml|
            CoreExhibition.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
