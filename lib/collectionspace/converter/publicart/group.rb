module CollectionSpace
  module Converter
    module PublicArt
      include Default
      class PublicArtGroup < Group
        ::PublicArtGroup = CollectionSpace::Converter::PublicArt::PublicArtGroup
        def convert
          run do |xml|
            CoreGroup.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
