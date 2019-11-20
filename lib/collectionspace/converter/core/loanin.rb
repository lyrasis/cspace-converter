module CollectionSpace
  module Converter
    module Core
      class CoreLoanIn < LoanIn
        ::CoreLoanIn = CollectionSpace::Converter::Core::CoreLoanIn
        def convert
          run do |xml|
            CoreLoanIn.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # TODO
        end
      end
    end
  end
end
