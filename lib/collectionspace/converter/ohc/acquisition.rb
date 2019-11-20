module CollectionSpace
  module Converter
    module OHC
      class OHCAcquisition < Acquisition
        ::OHCAcquisition = CollectionSpace::Converter::OHC::OHCAcquisition
        def convert
          run do |xml|
            CoreAcquisition.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # n/a same as core
        end
      end
    end
  end
end
