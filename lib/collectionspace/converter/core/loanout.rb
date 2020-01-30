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

        def self.pairs
          {
            'loanoutnumber' => 'loanOutNumber',
            'borrower' => 'borrower',
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
        end

        def self.map(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreLoanOut.pairs,
          pairstransforms = {
            'borrower' => {'authority' => ['orgauthorities', 'organization']},
            'borrowersauthorizer' => {'authority' => ['personauthorities', 'person']},
            'borrowersauthorizationdate' => {'special' => 'unstructured_date_stamp'},
            'borrowerscontact' => {'authority' => ['personauthorities', 'person']},
            'lendersauthorizer' => {'authority' => ['personauthorities', 'person']},
            'lendersauthorizationdate' => {'special' => 'unstructured_date_stamp'},
            'lenderscontact' => {'authority' => ['personauthorities', 'person']},
            'loanoutdate' => {'special' => 'unstructured_date_stamp'},
            'loanreturndate' => {'special' => 'unstructured_date_stamp'},
            'loanrenewalapplicationdate' => {'special' => 'unstructured_date_stamp'}
          })
          loanstatusdata = {
            'loanstatus' => 'loanStatus',
            'loanstatusdate' => 'loanStatusDate',
            'loanstatusnote' => 'loanStatusNote'
          }
          loanstatustransforms = {
            'loanstatus' => {'vocab' => 'loanoutstatus'},
            'loanstatusdate' => {'special' => 'unstructured_date_stamp'}
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
