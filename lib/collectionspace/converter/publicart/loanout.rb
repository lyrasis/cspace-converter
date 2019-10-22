module CollectionSpace
  module Converter
    module PublicArt
      include Default
      class PublicArtLoanOut < LoanOut
        ::PublicArtLoanOut = CollectionSpace::Converter::PublicArt::PublicArtLoanOut
        def convert
          run do |xml|
            CoreLoanOut.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
