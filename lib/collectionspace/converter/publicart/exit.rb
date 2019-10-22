module CollectionSpace
  module Converter
    module PublicArt
      include Default
      class PublicArtObjectExit < ObjectExit
        ::PublicArtObjectExit = CollectionSpace::Converter::PublicArt::PublicArtObjectExit
        def convert
          run do |xml|
            CoreObjectExit.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
