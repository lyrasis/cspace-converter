module CollectionSpace
  module Converter
    module PublicArt
      include Default
      class PublicArtConditionCheck < ConditionCheck
        ::PublicArtConditionCheck = CollectionSpace::Converter::PublicArt::PublicArtConditionCheck
        def convert
          run do |xml|
            CoreConditionCheck.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
