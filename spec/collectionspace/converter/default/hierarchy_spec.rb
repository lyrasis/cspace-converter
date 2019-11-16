require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Default::Hierarchy do
  let(:attributes) {
    {
      'subjectcsid' => '9ca81bd2-0663-455c-9c32',
      'subjectdocumenttype' => 'Conceptitem',
      'objectcsid' => 'cfcc6e92-1a51-41f7-8838',
      'objectdocumenttype' => 'Conceptitem'
    }
  }
  let(:hierarchy) { Lookup.default_hierarchy_class.new(attributes) }
  let(:doc) { Nokogiri::XML(hierarchy.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('hierarchy.xml') }
  let(:xpaths) {[
    '/document/*/subjectCsid',
    '/document/*/subjectDocumentType',
    '/document/*/objectCsid',
    '/document/*/objectDocumentType',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
