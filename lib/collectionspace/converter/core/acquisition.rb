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
          CSXML.add xml, 'acquisitionReferenceNumber', attributes["acquisitionreferencenumber"]

          CSXML.add_group_list xml, 'accessionDate', [{
            "dateDisplayDate" => CSDTP.parse(attributes["accessiondategroup"]).display_date,
            "dateEarliestScalarValue" => CSDTP.parse(attributes["accessiondategroup"]).earliest_scalar,
            "dateLatestScalarValue" => CSDTP.parse(attributes["accessiondategroup"]).latest_scalar,
          }]

          CSXML::Helpers.add_person xml, 'acquisitionAuthorizer', attributes["acquisitionauthorizer"]
          CSXML.add xml, 'acquisitionAuthorizerDate', CSDTP.parse(attributes['acquisitionauthorizerdate']).earliest_scalar

          CSXML.add_group_list xml, 'acquisitionDate', [{
            "dateDisplayDate" => CSDTP.parse(attributes["acquisitiondategroup"]).display_date,
            "dateEarliestScalarValue" => CSDTP.parse(attributes["acquisitiondategroup"]).earliest_scalar,
            "dateLatestScalarValue" => CSDTP.parse(attributes["acquisitiondategroup"]).latest_scalar,
          }]

          funding_currency = CSXML::Helpers.get_vocab('currency', attributes['acquisitionfundingcurrency'])
          funding_source = CSXML::Helpers.get_authority('orgauthorities', 'organization', attributes['acquisitionfundingcurrency'])
          CSXML.add_list xml, 'acquisitionFunding', [{
            'acquisitionFundingCurrency' => funding_currency,
            'acquisitionFundingValue' => attributes['acquisitionfundingvalue'],
            'acquisitionFundingSource' => funding_source,
            'acquisitionFundingSourceProvisos' => attributes['acquisitionfundingsourceprovisos'],
          }]
          CSXML.add xml, 'acquisitionMethod', attributes['acquisitionmethod']
          CSXML.add xml, 'acquisitionNote', attributes["acquisitionnote"]
          CSXML.add xml, 'acquisitionProvisos', attributes["acquisitionprovisos"]
          CSXML.add xml, 'acquisitionReason', attributes["acquisitionreason"]

          owners = []
          owners << { 'owner' => CSXML::Helpers.get_authority('personauthorities', 'person', attributes['ownerperson']) } if attributes['ownerperson']
          owners << { 'owner' => CSXML::Helpers.get_authority('orgauthorities', 'organization', attributes['ownerorganization']) } if attributes['ownerorganization']
          CSXML.add_repeat xml, 'owners', owners

          CSXML.add_repeat xml, 'acquisitionSources', [{'acquisitionSource' => attributes['acquisitionsource']}]
          CSXML.add xml, 'creditLine', attributes["creditline"]

          currency = CSXML::Helpers.get_vocab('currency', attributes['grouppurchasepricecurrency'])
          CSXML.add xml, 'groupPurchasePriceCurrency', currency
          CSXML.add xml, 'groupPurchasePriceValue', attributes['grouppurchasepricevalue']

          offer_currency = CSXML::Helpers.get_vocab('currency', attributes['objectofferpricecurrency'])
          CSXML.add xml, 'objectOfferPriceCurrency', offer_currency
          CSXML.add xml, 'objectOfferPriceValue', attributes['objectofferpricevalue']

          object_purchase_offer_currency = CSXML::Helpers.get_vocab('currency', attributes['objectpurchaseofferpricecurrency'])
          CSXML.add xml, 'objectPurchaseOfferPriceCurrency', object_purchase_offer_currency
          CSXML.add xml, 'objectPurchaseOfferPriceValue', attributes['objectpurchaseofferpricevalue']

          object_purchase_currency = CSXML::Helpers.get_vocab('currency', attributes['objectpurchasepricecurrency'])
          CSXML.add xml, 'objectPurchasePriceCurrency', object_purchase_currency
          CSXML.add xml, 'objectPurchasePriceValue', attributes['objectpurchasepricevalue']

          original_object_currency = CSXML::Helpers.get_vocab('currency', attributes['originalobjectpurchasepricecurrency'])
          CSXML.add xml, 'originalObjectPurchasePriceCurrency', original_object_currency
          CSXML.add xml, 'originalObjectPurchasePriceValue', attributes['originalobjectpurchasepricevalue']

          CSXML.add xml, 'transferOfTitleNumber', attributes['transferoftitlenumber']
          CSXML.add_repeat xml, 'fieldCollectionEventNames', [{'fieldCollectionEventName' => attributes['fieldcollectioneventname']}]
        end
      end
    end
  end
end
