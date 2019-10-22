module CollectionSpace
  module Converter
    module PublicArt
      include Default
      class PublicArtLoanIn < LoanIn
        ::PublicArtLoanIn = CollectionSpace::Converter::PublicArt::PublicArtLoanIn
        def convert
          run do |xml|
            CoreLoanIn.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
