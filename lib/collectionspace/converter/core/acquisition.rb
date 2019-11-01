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
          #acquisitionReferenceNumber
          CSXML.add xml, 'acquisitionReferenceNumber', attributes["acquisitionreferencenumber"]
=begin
          #accessionDateGroup
          CSXML.add_group_list xml, 'accessionDate', [{
           "dateDisplayDate" => attributes["accessiondategroup"],
           "dateEarliestScalarValue" => CSDTP.parse(attributes["accessiondategroup"]).earliest_scalar,
          }]
=end
          #acquisitionAuthorizer
          acquisition_authorizer = attributes["acquisitionauthorizer"]
          CSXML::Helpers.add_person xml, 'acquisitionAuthorizer', acquisition_authorizer if acquisition_authorizer
          CSXML.add xml, 'acquisitionAuthorizerDate', CSDTP.parse(attributes['acquisitionauthorizerdate']).earliest_scalar rescue nil
          #acquisitionDateGroupList
          CSXML.add_group_list xml, 'acquisitionDate', [{
           "dateDisplayDate" => attributes["acquisitiondategroup"],
           "dateEarliestScalarValue" => CSDTP.parse(attributes["acquisitiondategroup"]).earliest_scalar,
          }] rescue nil
          #acquisitionFunding
          funding_currency = CSURN.get_vocab_urn('currency', attributes['acquisitionfundingcurrency'])
          funding_source = CSURN.get_authority_urn('orgauthorities', 'organization', attributes['acquisitionfundingcurrency'])
          CSXML.add_list xml, 'acquisitionFunding', [{
           'acquisitionFundingCurrency' => funding_currency,
           'acquisitionFundingValue' => attributes['acquisitionfundingvalue'],
           'acquisitionFundingSource' => funding_source,
           'acquisitionFundingSourceProvisos' => attributes['acquisitionfundingsourceprovisos'],
          }]
          #acquisitionMethod
          CSXML.add xml, 'acquisitionMethod', attributes['acquisitionmethod']
          #acquisitionNote
          CSXML.add xml, 'acquisitionNote', attributes["acquisitionnote"]
          #acquisitionProvisos
          CSXML.add xml, 'acquisitionProvisos', attributes["acquisitionprovisos"]
          #acquisitionReason
          CSXML.add xml, 'acquisitionReason', attributes["acquisitionreason"]
          #owner
          owners = []
	  owners << { 'owner' => CSURN.get_authority_urn('personauthorities', 'person', attributes['ownerperson']) } if attributes['ownerperson']
	  owners << { 'owner' => CSURN.get_authority_urn('orgauthorities', 'organization', attributes['ownerorganization']) } if attributes['ownerorganization']
	  CSXML.add_repeat xml, 'owners', owners
          #acquisitionSource
          CSXML.add_repeat xml, 'acquisitionSources', [{'acquisitionSource' => attributes['acquisitionsource']}]
          #creditLine
          CSXML.add xml, 'creditLine', attributes["creditline"]
          #groupPurchasePrice
          currency = CSURN.get_vocab_urn('currency', attributes['grouppurchasepricecurrency'])
          CSXML.add xml, 'groupPurchasePriceCurrency', currency
          CSXML.add xml, 'groupPurchasePriceValue', attributes['grouppurchasepricevalue']
          #objectOfferPrice
          offer_currency = CSURN.get_vocab_urn('currency', attributes['objectofferpricecurrency'])
          CSXML.add xml, 'objectOfferPriceCurrency', offer_currency
          CSXML.add xml, 'objectOfferPriceValue', attributes['objectofferpricevalue']
          #objectPurchaseOfferPrice
          object_purchase_offer_currency = CSURN.get_vocab_urn('currency', attributes['objectpurchaseofferpricecurrency'])
          CSXML.add xml, 'objectPurchaseOfferPriceCurrency', object_purchase_offer_currency
          CSXML.add xml, 'objectPurchaseOfferPriceValue', attributes['objectpurchaseofferpricevalue']
          #objectPurchasePrice
          object_purchase_currency = CSURN.get_vocab_urn('currency', attributes['objectpurchasepricecurrency'])
          CSXML.add xml, 'objectPurchasePriceCurrency', object_purchase_currency
          CSXML.add xml, 'objectPurchasePriceValue', attributes['objectpurchasepricevalue']
          #originalObjectPurchasePrice
          original_object_currency = CSURN.get_vocab_urn('currency', attributes['originalobjectpurchasepricecurrency'])
          CSXML.add xml, 'originalObjectPurchasePriceCurrency', original_object_currency
          CSXML.add xml, 'originalObjectPurchasePriceValue', attributes['originalobjectpurchasepricevalue']
          #transferOfTitleNumber
          CSXML.add xml, 'transferOfTitleNumber', attributes['transferoftitlenumber']
          #fieldCollectionEventName
          CSXML.add_repeat xml, 'fieldCollectionEventNames', [{'fieldCollectionEventName' => attributes['fieldcollectioneventname']}]
        end
      end
    end
  end
end
