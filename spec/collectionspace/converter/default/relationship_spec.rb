require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Default::Relationship do
  let(:attributes) {
    {
      'subjectcsid' => '5ca81bd2-0663-455c-9c32',
      'subjectdocumenttype' => 'Acquisition',
      'objectcsid' => 'efcc6e92-1a51-41f7-8838',
      'objectdocumenttype' => 'CollectionObject'
    }
  }
  let(:hierarchy) { Lookup.default_relationship_class.new(attributes) }
  let(:doc) { Nokogiri::XML(hierarchy.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('relationship.xml') }
  let(:xpaths) {[
    '/document/*/subjectCsid',
    '/document/*/subjectDocumentType',
    '/document/*/relationshipType',
    '/document/*/predicate',
    '/document/*/objectCsid',
    '/document/*/objectDocumentType',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
