require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtValuationControl do
  let(:attributes) { get_attributes('publicart', 'valuationcontrol_publicart_all.csv') }
  let(:publicartvaluationcontrol) { PublicArtValuationControl.new(attributes) }
  let(:doc) { Nokogiri::XML(publicartvaluationcontrol.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('publicart_valuation.xml') }
  let(:p) { 'valuationcontrols_common' }
  let(:ext) { 'valuationcontrols_publicart' }
  let(:xpaths) {[
    "/document/#{p}/valuationcontrolRefNumber",
    { xpath: "/document/#{p}/valueAmountsList/valueAmounts[1]/valueCurrency", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{p}/valueAmountsList/valueAmounts[1]/valueCurrency", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    { xpath: "/document/#{p}/valueAmountsList/valueAmounts[2]/valueCurrency", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{p}/valueAmountsList/valueAmounts[2]/valueCurrency", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    "/document/#{p}/valueAmountsList/valueAmounts/valueAmount",
    "/document/#{p}/valueDate",
    "/document/#{p}/valueNote",
    "/document/#{p}/valueRenewalDate",
    "/document/#{p}/valueType",
    { xpath: "/document/#{p}/valueSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/valueSource", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/#{ext}/valueSourceRole", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{ext}/valueSourceRole", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
    "/document/#{ext}/insuranceGroupList/insuranceGroup/insuranceNote",
    "/document/#{ext}/insuranceGroupList/insuranceGroup/insuranceRenewalDate",
    { xpath: "/document/#{ext}/insuranceGroupList/insuranceGroup[1]/insurer", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{ext}/insuranceGroupList/insuranceGroup[1]/insurer", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: "/document/#{ext}/insuranceGroupList/insuranceGroup[2]/insurer", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{ext}/insuranceGroupList/insuranceGroup[2]/insurer", transform: ->(text) { CSURN.parse(text)[:subtype] } },
    "/document/#{ext}/insuranceGroupList/insuranceGroup/insurancePolicyNumber",
  ]}
  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('publicart', 'valuationcontrol_publicart_all.csv', 22) }
    let(:doc) { Nokogiri::XML(publicartvaluationcontrol.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('publicart_valuation_row22.xml') }
    let(:xpath_required) {[
      "/document/*/valuationcontrolRefNumber"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
