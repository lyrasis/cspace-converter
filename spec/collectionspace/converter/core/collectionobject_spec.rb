require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreCollectionObject do
  let(:attributes) { get_attributes('core', 'cataloging_core_excerpt.csv') }
  let(:corecollectionobject) { CoreCollectionObject.new(attributes) }
  let(:doc) { Nokogiri::XML(corecollectionobject.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_collectionobject.xml') }
  let(:xpaths) {[
    '/document/*/collection', # TODO
    '/document/*/objectNumber',
    '/document/*/measuredPartGroupList/measuredPartGroup/dimensionSummary',
    '/document/*/materialGroupList/materialGroup/material',
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
