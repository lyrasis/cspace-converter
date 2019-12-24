require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtCollectionObject do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'publicart.collectionspace.org'
  end

  let(:common) { 'collectionobjects_common' }
  
  describe '#map' do
    let(:pa) { 'collectionobjects_publicart' }

    context 'given full sample data' do
      let(:attributes) { get_attributes('publicart', 'collectionobject.csv') }
      let(:pacollectionobject) { PublicArtCollectionObject.new(attributes) }
      let(:doc) { get_doc(pacollectionobject) }
      let(:record) { get_fixture('publicart_collectionobject1.xml') }


      it 'maps title fields correctly' do
        xpaths = [
          "/document/#{common}/titleGroupList/titleGroup[2]/title",
          { xpath: "/document/#{common}/titleGroupList/titleGroup[2]/titleLanguage", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{common}/titleGroupList/titleGroup[2]/titleType",
          "/document/#{common}/titleGroupList/titleGroup[2]/titleTranslationSubGroupList/titleTranslationSubGroup[2]/titleTranslation",
          { xpath: "/document/#{common}/titleGroupList/titleGroup[2]/titleTranslationSubGroupList/titleTranslationSubGroup[2]/titleTranslationLanguage", transform: ->(text) {CSURN.parse(text)[:label].downcase} }
        ]
        puts doc
        test_converter(doc, record, xpaths)
      end 

      it 'maps responsible department terms correctly' do
        xpaths = [
          "/document/#{common}/responsibleDepartments/responsibleDepartment[1]",
          "/document/#{common}/responsibleDepartments/responsibleDepartment[2]",
#          { xpath: "/document/#{common}/responsibleDepartments/responsibleDepartment[1]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
#          { xpath: "/document/#{common}/responsibleDepartments/responsibleDepartment[2]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
        ]
        puts doc
        test_converter(doc, record, xpaths)
      end 

    end # context 'given full sample data'
  end # describe #map

end
