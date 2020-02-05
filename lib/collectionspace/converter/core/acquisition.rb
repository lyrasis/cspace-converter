module CollectionSpace
  module Converter
    module Core
      class CoreAcquisition < Acquisition
        ::CoreAcquisition = CollectionSpace::Converter::Core::CoreAcquisition
        def convert
          run do |xml|
            CoreAcquisition.map(xml, attributes)
          end
        end

       def self.map(xml, attributes)
         pairs = {
            'acquisitionreferencenumber' => 'acquisitionReferenceNumber',
            'acquisitionauthorizer' => 'acquisitionAuthorizer',
            'acquisitionauthorizerdate' => 'acquisitionAuthorizerDate',
            'acquisitionmethod' => 'acquisitionMethod',
            'acquisitionnote' => 'acquisitionNote',
            'acquisitionprovisos' => 'acquisitionProvisos',
            'acquisitionreason' => 'acquisitionReason',
            'creditline' => 'creditLine',
            'grouppurchasepricecurrency' => 'groupPurchasePriceCurrency',
            'grouppurchasepricevalue' => 'groupPurchasePriceValue',
            'objectofferpricecurrency' => 'objectOfferPriceCurrency',
            'objectofferpricevalue' => 'objectOfferPriceValue',
            'objectpurchaseofferpricecurrency' => 'objectPurchaseOfferPriceCurrency',
            'objectpurchaseofferpricevalue' => 'objectPurchaseOfferPriceValue',
            'objectpurchasepricecurrency' => 'objectPurchasePriceCurrency',
            'objectpurchasepricevalue' => 'objectPurchasePriceValue',
            'originalobjectpurchasepricecurrency' => 'originalObjectPurchasePriceCurrency',
            'originalobjectpurchasepricevalue' => 'originalObjectPurchasePriceValue',
            'transferoftitlenumber' => 'transferOfTitleNumber'
          }
          pairstransforms = {
            'acquisitionauthorizer' => {'authority' => ['personauthorities', 'person']},
            'acquisitionauthorizerdate' => {'special' => 'unstructured_date_stamp'},
            'grouppurchasepricecurrency' => {'vocab' => 'currency'},
            'objectofferpricecurrency' => {'vocab' => 'currency'},
            'objectpurchaseofferpricecurrency' => {'vocab' => 'currency'},
            'objectpurchasepricecurrency' => {'vocab' => 'currency'},
            'originalobjectpurchasepricecurrency' => {'vocab' => 'currency'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)

          repeats = { 
            'ownerperson' => ['owners', 'owner'],
            'ownerorganization' => ['owners', 'owner'],
            'acquisitionsourceperson' => ['acquisitionSources', 'acquisitionSource'],
            'acquisitionsourceorganization' => ['acquisitionSources', 'acquisitionSource'],
            'fieldcollectioneventname' => ['fieldCollectionEventNames', 'fieldCollectionEventName']
          }
          repeatstransforms = {
            'acquisitionsourceperson' => {'authority' => ['personauthorities', 'person']},
            'acquisitionsourceorganization' => {'authority' => ['orgauthorities', 'organization']},
            'ownerperson' => {'authority' => ['personauthorities', 'person']},
            'ownerorganization' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          
          CSXML::Helpers.add_date_group(xml, 'accessionDate', CSDTP.parse(attributes['accessiondate']))

          CSXML::Helpers.add_date_group_list(xml, 'acquisitionDate', attributes['acquisitiondate'])


          funding_data = {
            'acquisitionfundingcurrency' => 'acquisitionFundingCurrency',
            'acquisitionfundingvalue' => 'acquisitionFundingValue',
            'acquisitionfundingsourceorganization' => 'acquisitionFundingSource',
            'acquisitionfundingsourceperson' => 'acquisitionFundingSource',
            'acquisitionfundingsourceprovisos' => 'acquisitionFundingSourceProvisos',
          }
          funding_transforms = {
            'acquisitionfundingcurrency' => {'vocab' => 'currency'},
            'acquisitionfundingsourceorganization' => {'authority' => ['orgauthorities', 'organization']},
            'acquisitionfundingsourceperson' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'acquisitionFunding',
            funding_data,
            funding_transforms,
            list_suffix: 'List',
            group_suffix: ''
          )

          app_data = {
            'approvalstatus' => 'approvalStatus',
            'approvalgroup' => 'approvalGroup',
            'approvalnote' => 'approvalNote',
            'approvaldate' => 'approvalDate',
            'approvalindividual' => 'approvalIndividual'
          }
          app_transforms = {
            'approvalstatus' => {'vocab' => 'deaccessionapprovalstatus'},
            'approvalgroup' => {'vocab' => 'deaccessionapprovalgroup'},
            'approvaldate' => {'special' => 'unstructured_date_stamp'},
            'approvalindividual' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'approval',
            app_data,
            app_transforms
          )
        end
      end
    end
  end
end
