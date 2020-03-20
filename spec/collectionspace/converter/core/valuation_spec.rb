require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreValuationControl do
  let(:attributes) { get_attributes('core', 'valuationcontrol_core_all.csv') }
  let(:corevaluationcontrol) { CoreValuationControl.new(attributes) }
  let(:doc) { Nokogiri::XML(corevaluationcontrol.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_valuation_control.xml') }
  let(:xpaths) {[
    '/document/*/valuationcontrolRefNumber',
    { xpath: '/document/*/valueAmountsList/valueAmounts[1]/valueCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/valueAmountsList/valueAmounts[1]/valueCurrency', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/valueAmountsList/valueAmounts[2]/valueCurrency', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/valueAmountsList/valueAmounts[2]/valueCurrency', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/valueAmountsList/valueAmounts/valueAmount',
    '/document/*/valueDate',
    '/document/*/valueNote',
    '/document/*/valueRenewalDate',
    '/document/*/valueType',
    { xpath: '/document/*/valueSource', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/valueSource', transform: ->(text) { CSURN.parse(text)[:subtype] } },
  ]}
  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'valuationcontrol_core_all.csv', 22) }
    let(:doc) { Nokogiri::XML(corevaluationcontrol.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_valuation_control_row22.xml') }
    let(:xpath_required) {[
      '/document/*/valuationcontrolRefNumber'
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
