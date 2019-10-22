require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreCollectionObject do

  let(:attributes) { get_attributes('core', 'sample_data_cataloging_core_excerpt.csv') }
  let(:corecollectionobject) { CoreCollectionObject.new(attributes) }
  let(:doc) { Nokogiri::XML(corecollectionobject.convert, nil, 'UTF-8') }

  it "Maps attributes correctly" do
    expect(doc.xpath('/document/*/objectNumber').text).to eq('20CS.001.0001')
  end

end
