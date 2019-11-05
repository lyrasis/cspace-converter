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
          CSXML.add xml, 'loanOutNumber', attributes["loanoutnumber"]
=begin
          CSXML::Helpers.add_organization xml, 'borrower', attributes["borrower"]
          CSXML::Helpers.add_person xml, 'borrowersAuthorizer', attributes["borrowersauthorizer"]
          CSXML.add xml, 'borrowersAuthorizationDate', CSDTP.parse(attributes['borrowersauthorizationdate']).earliest_scalar
          CSXML::Helpers.add_person xml, 'borrowersContact', attributes["borrowerscontact"]
          CSXML::Helpers.add_person xml, 'lendersAuthorizer', attributes["lendersauthorizer"]
          CSXML.add xml, 'lendersAuthorizationDate', CSDTP.parse(attributes["lendersauthorizationdate"]).earliest_scalar
          CSXML::Helpers.add_person xml, 'lendersContact', attributes["lenderscontact"]
          CSXML.add xml, 'loanOutDate', CSDTP.parse(attributes["loanoutdate"]).earliest_scalar
          CSXML.add xml, 'loanReturnDate', CSDTP.parse(attributes["loanreturndate"]).earliest_scalar
          CSXML.add xml, 'loanRenewalApplicationDate', CSDTP.parse(attributes["loanrenewalapplicationdate"]).earliest_scalar
          CSXML.add xml, 'specialConditionsOfLoan', attributes["specialconditionsofloan"]
          CSXML.add xml, 'loanOutNote', scrub_fields([attributes["loanoutnote"]])
          CSXML.add xml, 'loanPurpose', attributes["loanpurpose"]
          CSXML.add_group_list xml, 'loanStatus', [{
            "loanStatus" =>  CSXML::Helpers.get_vocab('loanoutstatus', attributes["loanstatus"]),
            "loanStatusDate" => CSDTP.parse(attributes["loanstatusdate"]).earliest_scalar,
            "loanStatusNote" => attributes["loanstatusnote"]
          }]
=end
        end
      end
    end
  end
end
