module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtAcquisition < Acquisition
        ::PublicArtAcquisition = CollectionSpace::Converter::PublicArt::PublicArtAcquisition
        def convert
          run do |xml|
            CoreAcqusition.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
