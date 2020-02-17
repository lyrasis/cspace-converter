require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreGroup do
  let(:attributes) { get_attributes('core', 'group_core_all.csv') }
  let(:coregroup) { CoreGroup.new(attributes) }
  let(:doc) { Nokogiri::XML(coregroup.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_group.xml') }
  let(:xpaths) {[
    '/document/*/groupEarliestSingleDate',
    '/document/*/groupLatestDate',
    { xpath: '/document/*/owner', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/title',
    '/document/*/responsibleDepartment',
    '/document/*/scopeNote',
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'group_core_all.csv', 7) }
    let(:doc) { Nokogiri::XML(coregroup.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_group_row7.xml') }
    let(:xpath_required) {[
      '/document/*/title'
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
