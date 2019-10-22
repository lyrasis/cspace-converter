module CollectionSpace
  module Converter
    module PublicArt
      include Default
      class PublicArtIntake < Intake
        ::PublicArtIntake = CollectionSpace::Converter::PublicArt::PublicArtIntake
        def convert
          run do |xml|
            CoreIntake.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
