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
          pairs = {
            'loanoutnumber' => 'loanOutNumber',
            'borrowerorganization' => 'borrower',
            'borrowerperson' => 'borrower',
            'borrowersauthorizer' => 'borrowersAuthorizer',
            'borrowersauthorizationdate' => 'borrowersAuthorizationDate',
            'borrowerscontact' => 'borrowersContact',
            'lendersauthorizer' => 'lendersAuthorizer',
            'lendersauthorizationdate' => 'lendersAuthorizationDate',
            'lenderscontact' => 'lendersContact',
            'loanoutdate' => 'loanOutDate',
            'loanreturndate' => 'loanReturnDate',
            'loanrenewalapplicationdate' => 'loanRenewalApplicationDate',
            'specialconditionsofloan' => 'specialConditionsOfLoan',
            'loanoutnote' => 'loanOutNote',
            'loanpurpose' => 'loanPurpose'
          }
          pairstransforms = {
            'borrowerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'borrowerperson' => {'authority' => ['personauthorities', 'person']},
            'borrowersauthorizer' => {'authority' => ['personauthorities', 'person']},
            'borrowersauthorizationdate' => {'special' => 'unstructured_date_stamp'},
            'borrowerscontact' => {'authority' => ['personauthorities', 'person']},
            'lendersauthorizer' => {'authority' => ['personauthorities', 'person']},
            'lendersauthorizationdate' => {'special' => 'unstructured_date_stamp'},
            'lenderscontact' => {'authority' => ['personauthorities', 'person']},
            'loanoutdate' => {'special' => 'unstructured_date_stamp'},
            'loanreturndate' => {'special' => 'unstructured_date_stamp'},
            'loanrenewalapplicationdate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          #loanStatusGroupList, loanStatusGroup
          loanstatusdata = {
            'loanstatus' => 'loanStatus',
            'loanstatusdate' => 'loanStatusDate',
            'loanstatusnote' => 'loanStatusNote',
            'loanindividual' => 'loanIndividual',
            'loangroup' => 'loanGroup'
          }
          loanstatustransforms = {
            'loanstatus' => {'vocab' => 'loanoutstatus'},
            'loanstatusdate' => {'special' => 'unstructured_date_stamp'},
            'loanindividual' => {'authority' => ['personauthorities', 'person']},
            'loangroup' => {'vocab' => 'deaccessionapprovalgroup'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'loanStatus',
            loanstatusdata,
            loanstatustransforms
          )
        end
      end
    end
  end
end
