require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreObjectExit do
  let(:attributes) { get_attributes('core', 'objectexit_core_all.csv') }
  let(:coreexit) { CoreObjectExit.new(attributes) }
  let(:doc) { Nokogiri::XML(coreexit.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_exit.xml') }
  let(:xpaths) {[
    '/document/*/exitNumber',
  ]}

  xit "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
