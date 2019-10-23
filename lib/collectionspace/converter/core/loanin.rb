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
          CSXML.add xml, 'loanInNumber', attributes["loan_in_number"]
          CSXML.add_group_list xml, 'lender', [{
            "lender" => CSURN.get_authority_urn('orgauthorities', 'organization', attributes["lender"]),
            "lendersAuthorizer" => CSURN.get_authority_urn('personauthorities', 'person', attributes["lender's_authorizer"]),
          }] if attributes["lender's_authorizer"]
          CSXML::Helpers.add_persons xml, 'borrowersAuthorizer', [attributes["borrower's_authorizer"]]
          CSXML.add_group_list xml, 'loanStatus', [{
            "loanStatus" =>  CSURN.get_vocab_urn('loanoutstatus', attributes["loan_status"]),
            "loanStatusDate" => attributes["loan_status_date"],
          }] if attributes["loan_status"]
          CSXML.add xml, 'loanInDate', attributes["loan_in_date"]
          CSXML.add xml, 'loanInNote', scrub_fields([attributes["loan_in_note"]])
        end
      end
    end
  end
end
