module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtValuationControl < ValuationControl
        ::PublicArtValuationControl = CollectionSpace::Converter::PublicArt::PublicArtValuationControl
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:valuationcontrols_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/valuationcontrol',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtValuationControl.map(xml, attributes, config)
            end


            xml.send(
              'ns2:valuationcontrols_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/valuationcontrol/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtValuationControl.extension(xml, attributes)
            end
          end
        end       

        def self.map(xml, attributes, config)
          pairs = {
            'valuationcontrolrefnumber' => 'valuationcontrolRefNumber',
            'valuedate' => 'valueDate',
            'valuenote' => 'valueNote',
            'valuerenewaldate' => 'valueRenewalDate',
            'valuetype' => 'valueType',
            'valuesourceorganization' => 'valueSource',
            'valuesourceperson' => 'valueSource',
          }
          pairstransforms = {
            'valuedate' => {'special' => 'unstructured_date_stamp'},
            'valuerenewaldate' => {'special' => 'unstructured_date_stamp'},
            'valuesourceorganization' => {'authority' => ['orgauthorities', 'organization']},
            'valuesourceperson' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          #valueAmountsList, valueAmounts
          valueamounts_data = {
            'valuecurrency' => 'valueCurrency',
            'valueamount' => 'valueAmount'
          }
          valueamounts_transforms = {
            'valuecurrency' => {'vocab' => 'currency'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'valueAmounts',
            valueamounts_data,
            valueamounts_transforms,
            list_suffix: 'List',
            group_suffix: ''
          )
 
          def self.extension(xml, attributes)
          pairs = {
            'valuesourcerole' => 'valueSourceRole'
          }
          pairs_transforms = {
            'valuesourcerole' => {'vocab' => 'valuationsourcerole'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
          #insuranceGroupList, insuranceGroup
          insurance_data = {
            "insurancenote" => "insuranceNote",
            "insurancerenewaldate" => "insuranceRenewalDate",
            "insurer" => "insurer",
            "insurancepolicynumber" => "insurancePolicyNumber"
          }
          insurance_transforms = {
            'insurancerenewaldate' => {'special' => 'unstructured_date_stamp'},
            'insurer' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'insurance',
            insurance_data,
            insurance_transforms
          )
        end
        end
      end
    end
  end
end
