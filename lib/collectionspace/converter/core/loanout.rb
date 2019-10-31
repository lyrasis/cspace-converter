module CollectionSpace
  module Converter
    module Core
      class CoreLoanOut < LoanOut
        ::CoreLoanOut = CollectionSpace::Converter::Core::CoreLoanOut
        def convert
          run do |xml|
            CoreLoanOut.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'loanOutNumber', attributes["loan_out_number"]
          CSXML::Helpers.add_organization xml, 'borrower', attributes["borrower"]
          CSXML::Helpers.add_person xml, 'borrowersAuthorizer', attributes["borrower's_authorizer"]
          CSXML::Helpers.add_person xml, 'lendersAuthorizer', attributes["lender's_authorizer"]
          CSXML.add_group_list xml, 'loanStatus', [{
            "loanStatus" =>  CSXML::Helpers.get_vocab('loanoutstatus', attributes["loan_status"]),
            "loanStatusDate" => attributes["loan_status_date"],
          }]
          CSXML.add xml, 'loanOutDate', attributes["loan_out_date"]
          CSXML.add xml, 'loanOutNote', scrub_fields([attributes["loan_out_note"]])
        end
      end
    end
  end
end
