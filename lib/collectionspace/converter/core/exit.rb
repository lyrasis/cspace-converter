module CollectionSpace
  module Converter
    module Core
      class CoreObjectExit < ObjectExit
        ::CoreObjectExit = CollectionSpace::Converter::Core::CoreObjectExit
        def convert
          run do |xml|
            CoreObjectExit.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          pairs = {
              'exitnumber' => 'exitNumber',
              'currentownerperson' => 'currentOwner',
              'currentownerorganization' => 'currentOwner',
              'depositororganization' => 'depositor',
              'depositorperson' => 'depositor',
              'exitnote' => 'exitNote',
              'exitquantity' => 'exitQuantity',
              'exitreason' => 'exitReason',
              'packingnote' => 'packingNote',
              'displosalnewobjectnumber' => 'displosalNewObjectNumber',
              'deaccessionauthorizer' => 'deaccessionAuthorizer',
              'authorizationdate' => 'authorizationDate',
              'deaccessiondate' => 'deaccessionDate',
              'disposaldate' => 'disposalDate',
              'disposalmethod' => 'disposalMethod',
              'disposalreason' => 'displosalReason',
              'disposalprovisos' => 'displosalProvisos',
              'disposalproposedrecipientperson' => 'disposalProposedRecipient',
              'disposalproposedrecipientorganization' => 'disposalProposedRecipient',
              'disposalrecipientperson' => 'disposalRecipient',
              'disposalrecipientorganization' => 'disposalRecipient',
              'disposalnote' => 'displosalNote',
              'disposalcurrency' => 'disposalCurrency',
              'disposalvalue' => 'displosalValue',
              'groupdisposalcurrency' => 'groupDisposalCurrency',
              'groupdisposalvalue' => 'groupDisplosalValue'
            }
          pairstransforms = {
            'currentownerperson' => {'authority' => ['personauthorities', 'person']},
            'currentownerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'depositororganization' => {'authority' => ['orgauthorities', 'organization']},
            'depositorperson' => {'authority' => ['personauthorities', 'person']},
            'deaccessionauthorizer' => {'authority' => ['personauthorities', 'person']},
            'authorizationdate' => {'special' => 'unstructured_date_stamp'},
            'deaccessiondate' => {'special' => 'unstructured_date_stamp'},
            'disposaldate' => {'special' => 'unstructured_date_stamp'},
            'disposalmethod' => {'vocab' => 'disposalmethod'},
            'disposalproposedrecipientperson' => {'authority' => ['personauthorities', 'person']},
            'disposalproposedrecipientorganization' => {'authority' => ['orgauthorities', 'organization']},
            'disposalrecipientperson' => {'authority' => ['personauthorities', 'person']},
            'disposalrecipientorganization' => {'authority' => ['orgauthorities', 'organization']},
            'disposalcurrency' => {'vocab' => 'currency'},
            'groupdisposalcurrency' => {'vocab' => 'currency'}
          }
          repeats = { 
            'exitmethod' => ['exitMethods', 'exitMethod'],
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          CSXML::Helpers.add_repeats(xml, attributes, repeats)
          CSXML::Helpers.add_date_group(xml, 'exitDate', CSDTP.parse(attributes['exitdategroup']))
          #deacApprovalGroupList
          approval = {
            'deaccessionapprovalgroup' => 'deaccessionApprovalGroup',
            'deaccessionapprovalstatus' => 'deaccessionApprovalStatus',
            'deaccessionapprovaldate' => 'deaccessionApprovalDate',
            'deaccessionapprovalindividual' => 'deaccessionApprovalIndividual',
            'deaccessionapprovalnote' => 'deaccessionApprovalNote'

          }
          approvaltransforms = {
            'deaccessionapprovalgroup' => {'vocab' => 'deaccessionapprovalgroup'},
            'deaccessionapprovalstatus' => {'vocab' => 'deaccessionapprovalstatus'},
            'deaccessionapprovaldate' => {'special' => 'unstructured_date_stamp'},
            'deaccessionapprovalindividual' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'deacApproval',
            approval,
            approvaltransforms
          )
        end
      end
    end
  end
end
