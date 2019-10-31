module CollectionSpace
  module Converter
    module Core
      class CoreValuationControl < ValuationControl
        ::CoreValuationControl = CollectionSpace::Converter::Core::CoreValuationControl
        def convert
          run do |xml|
            CoreValuationControl.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'valuationcontrolRefNumber', attributes["valuation_control_reference_number"]
          value_source = attributes["source"]
          CSXML::Helpers.add_persons xml, 'valueSource', [value_source]
          CSXML.add xml, 'valueNote', attributes["valuation_note"]
          CSXML.add_list xml, 'valueAmounts', [{
            "valueAmount" => attributes['amount'],
            "valueCurrency" => CSXML::Helpers.get_vocab('currency', attributes['currency']),
          }]
          CSXML.add xml, 'valueDate', CSDTP.parse(attributes['date']).parsed_datetime
        end
      end
    end
  end
end
