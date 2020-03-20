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
          pairs = {
            'loaninnumber' => 'loanInNumber',
            'borrowerscontact' => 'borrowersContact',
            'borrowersauthorizer' => 'borrowersAuthorizer',
            'borrowersauthorizationdate' => 'borrowersAuthorizationDate',
            'loaninconditions' => 'loanInConditions',
            'loanindate' => 'loanInDate',
            'loanreturndate' => 'loanReturnDate',
            'loanrenewalapplicationdate' => 'loanRenewalApplicationDate',
            'loaninnote' => 'loanInNote',
            'loanpurpose' => 'loanPurpose'
          }
          pairstransforms = {
            'borrowerscontact' => {'authority' => ['personauthorities', 'person']},
            'borrowersauthorizer' => {'authority' => ['personauthorities', 'person']},
            'borrowersauthorizationdate' => {'special' => 'unstructured_date_stamp'},
            'loanindate' => {'special' => 'unstructured_date_stamp'},
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
          #lenderGroupList, lenderGroup
          lenderdata = {
            'lenderorganization' => 'lender',
            'lenderperson' => 'lender',
            'lendersauthorizer' => 'lendersAuthorizer',
            'lendersauthorizationdate' => 'lendersAuthorizationDate',
            'lenderscontact' => 'lendersContact',
          }
          lendertransforms = {
            'lenderorganization' => {'authority' => ['orgauthorities', 'organization']},
            'lenderperson' => {'authority' => ['personauthorities', 'person']},
            'lendersauthorizer' => {'authority' => ['personauthorities', 'person']},
            'lendersauthorizationdate' => {'special' => 'unstructured_date_stamp'},
            'lenderscontact' => {'authority' => ['personauthorities', 'person']},
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'lender',
            lenderdata,
            lendertransforms
          )

        end
      end
    end
  end
end
