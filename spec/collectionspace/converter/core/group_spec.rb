require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreGroup do
  let(:attributes) { get_attributes('core', 'sample_data_group_core_all.csv') }
  let(:coregroup) { CoreGroup.new(attributes) }
  let(:doc) { Nokogiri::XML(coregroup.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_group.xml') }
  let(:xpaths) {[
    '/document/*/title',
    '/document/*/responsibleDepartment',
    '/document/*/scopeNote',
  ]}

  xit "Maps attributes correctly" do
    xpaths.each do |xpath|
      expect(doc.xpath(xpath).text).not_to be_empty
      expect(
        doc.xpath(xpath).text
      ).to eq(
        record.xpath(xpath).text
      )
    end
  end
end
