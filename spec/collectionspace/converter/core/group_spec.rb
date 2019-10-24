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

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
