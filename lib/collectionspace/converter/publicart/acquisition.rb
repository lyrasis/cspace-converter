module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtAcquisition < CoreAcquisition
        ::PublicArtAcquisition = CollectionSpace::Converter::PublicArt::PublicArtAcquisition
        def redefined_fields
          @redefined.concat([
            # not in publicart
            'transferoftitlenumber',
            'grouppurchasepricecurrency',
            'grouppurchasepricevalue',
            'objectofferpricecurrency',
            'objectofferpricevalue',
            'objectpurchaseofferpricecurrency',
            'objectpurchaseofferpricevalue',
            'objectpurchasepricecurrency',
            'objectpurchasepricevalue',
            'originalobjectpurchasepricecurrency',
            'originalobjectpurchasepricevalue',
            'approvalgroup',
            'approvalindividual',
            'approvalstatus',
            'approvaldate',
            'approvalnote',
            'acquisitionprovisos',
            'fieldcollectioneventname',
            'accessiondategroup',
            'acquisitiondategroup',
            # overridden by publicart
            'acquisitionmethod',
            'acquisitionsource',
            'owner',
            'acquisitionfundingsource',
            'acquisitionfundingcurrency',
            'acquisitionfundingvalue',
            'acquisitionfundingsourceprovisos'
          ])
          super
        end

        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:acquisitions_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/acquisition',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtAcquisition.map_common(xml, attributes, redefined_fields)
            end

            xml.send(
              'ns2:acquisitions_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/acquisition/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtAcquisition.map_publicart(xml, attributes)
            end

            xml.send(
              'ns2:acquisitions_commission',
              'xmlns:ns2' => 'http://collectionspace.org/services/acquisition/domain/commission',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtAcquisition.map_commission(xml, attributes, redefined_fields)
            end
          end
        end

        def self.map_common(xml, attributes, redefined)
          CoreAcquisition.map_common(xml, attributes.merge(redefined))
          pairs = {
            'acquisitionmethod' => 'acquisitionMethod',
          }
          pairstransforms = {
            'acquisitionmethod' => {'vocab' => 'acquisitionmethod'},
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          repeats = { 
            'ownerpersonlocal' => ['owners', 'owner'],
            'ownerpersonshared' => ['owners', 'owner'],
            'ownerorganizationlocal' => ['owners', 'owner'],
            'ownerorganizationshared' => ['owners', 'owner'],
            'acquisitionsourcepersonlocal' => ['acquisitionSources', 'acquisitionSource'],
            'acquisitionsourcepersonshared' => ['acquisitionSources', 'acquisitionSource'],
            'acquisitionsourceorganizationlocal' => ['acquisitionSources', 'acquisitionSource'],
            'acquisitionsourceorganizationshared' => ['acquisitionSources', 'acquisitionSource']
          }
          repeatstransforms = {
            'acquisitionsourcepersonlocal' => {'authority' => ['personauthorities', 'person']},
            'acquisitionsourcepersonshared' => {'authority' => ['personauthorities', 'person_shared']},
            'acquisitionsourceorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'acquisitionsourceorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']},
            'ownerpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'ownerpersonshared' => {'authority' => ['personauthorities', 'person_shared']},
            'ownerorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'ownerorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          #acquisitionFundingList
          funding_data = {
            'acquisitionfundingcurrency' => 'acquisitionFundingCurrency',
            'acquisitionfundingvalue' => 'acquisitionFundingValue',
            'acquisitionfundingsourceorganizationlocal' => 'acquisitionFundingSource',
            'acquisitionfundingsourceorganizationshared' => 'acquisitionFundingSource',
            'acquisitionfundingsourcepersonlocal' => 'acquisitionFundingSource',
            'acquisitionfundingsourcepersonshared' => 'acquisitionFundingSource',
            'acquisitionfundingsourceprovisos' => 'acquisitionFundingSourceProvisos',
          }
          funding_transforms = {
            'acquisitionfundingcurrency' => {'vocab' => 'currency'},
            'acquisitionfundingsourceorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'acquisitionfundingsourceorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']},
            'acquisitionfundingsourcepersonlocal' => {'authority' => ['personauthorities', 'person']},
            'acquisitionfundingsourcepersonshared' => {'authority' => ['personauthorities', 'person_shared']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'acquisitionFunding',
            funding_data,
            funding_transforms,
            list_suffix: 'List',
            group_suffix: ''
          )
        end

        def self.map_publicart(xml, attributes)
          pairs = {
            'publicartaccessiondate' => 'accessionDate'
          }
          pairstransforms = {
            'publicartaccessiondate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          repeats = { 
            'publicartacquisitiondate' => ['acquisitionDates', 'acquisitionDate']
          }
          repeatstransforms = {
            'publicartacquisitiondate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
        end

        def self.map_commission(xml, attributes, redefined)
          Commission.map_commission(xml, attributes.merge(redefined))
        end
      end
    end
  end
end
