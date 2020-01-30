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

         def self.pairs
          {
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
        end

       def self.repeats
          { 
            'ownerperson' => ['owners', 'owner'],
            'ownerorganization' => ['owners', 'owner'],
            'acquisitionsource' => ['acquisitionSources', 'acquisitionSource'],
            'fieldcollectioneventname' => ['fieldCollectionEventNames', 'fieldCollectionEventName']
          }
        end 

        def self.map(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreAcquisition.pairs,
          pairstransforms = {
            'acquisitionauthorizer' => {'authority' => ['personauthorities', 'person']},
            'acquisitionauthorizerdate' => {'special' => 'unstructured_date_stamp'},
            'grouppurchasepricecurrency' => {'vocab' => 'currency'},
            'objectofferpricecurrency' => {'vocab' => 'currency'},
            'objectofferpricecurrency' => {'vocab' => 'currency'},
            'objectpurchaseofferpricecurrency' => {'vocab' => 'currency'},
            'objectpurchasepricecurrency' => {'vocab' => 'currency'},
            'originalobjectpurchasepricecurrency' => {'vocab' => 'currency'}
          })
          CSXML::Helpers.add_repeats(xml, attributes, CoreAcquisition.repeats,
          repeatstransforms = {
            'acquisitionsource' => {'authority' => ['personauthorities', 'person']},
            'ownerperson' => {'authority' => ['personauthorities', 'person']},
            'ownerorganization' => {'authority' => ['orgauthorities', 'organization']}
          })
          CSXML::Helpers.add_date_group(xml, 'accessionDate', CSDTP.parse(attributes['accessiondategroup']))
          acqdate = CSDR.split_mvf attributes, 'acquisitiondategroup'
          acqdate.each_with_index do |acqd, index|
            CSXML::Helpers.add_date_group_list(xml, 'acquisitionDate', [CSDTP.parse(acqd)])
          end
          acquistionfunding = []
          fundingcurrency = CSDR.split_mvf attributes, 'acquisitionfundingcurrency'
          fundingvalue = CSDR.split_mvf attributes, 'acquisitionfundingvalue'
          fundingsourceorg = CSDR.split_mvf attributes, 'acquisitionfundingsourceorganization'
          fundingsourceperson = CSDR.split_mvf attributes, 'acquisitionfundingsourceperson' 
          fundingsourceprov = CSDR.split_mvf attributes, 'acquisitionfundingsourceprovisos'
          fundingcurrency.each_with_index do |fc, index|
            acquistionfunding << {"acquisitionFundingCurrency" => CSXML::Helpers.get_vocab('currency', fc), "acquisitionFundingValue" => fundingvalue[index], "acquisitionFundingSource" => CSXML::Helpers.get_authority('orgauthorities', 'organization', fundingsourceorg[index]), "acquisitionFundingSourceProvisos" => fundingsourceprov[index]} if fundingsourceorg[index]
            acquistionfunding << {"acquisitionFundingCurrency" => CSXML::Helpers.get_vocab('currency', fc), "acquisitionFundingValue" => fundingvalue[index], "acquisitionFundingSource" => CSXML::Helpers.get_authority('personauthorities', 'person', fundingsourceperson[index]), "acquisitionFundingSourceProvisos" => fundingsourceprov[index]} if fundingsourceperson[index]
          end
          CSXML.add_list xml, 'acquisitionFunding', acquistionfunding
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
