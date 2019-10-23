module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtMovement < Movement
        ::PublicArtMovement = CollectionSpace::Converter::PublicArt::PublicArtMovement
        def convert
          run do |xml|
            CoreMovement.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
