require 'rails_helper'

RSpec.describe CollectionSpace::Converter::OHC::OHCCollectionObject do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'cspace.ohiohistory.org'
  end

  let(:common) { 'collectionobjects_common' }
  
  describe '#map' do
    let(:ohc) { 'collectionobjects_ohc' }

    context 'sample data row 2' do
      let(:attributes) { get_attributes('ohc', 'collectionobject_ohc_specific.csv') }
      let(:ohccollectionobject) { OHCCollectionObject.new(attributes) }
      let(:doc) { get_doc(ohccollectionobject) }
      let(:record) { get_fixture('ohc_collectionobject_row2.xml') }

      it "Maps OHC-specific fields correctly" do
        xpaths = [
          "/document/#{ohc}/descriptionLevel",
          { xpath: "/document/#{ohc}/namedTimePeriods/namedTimePeriod[1]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{ohc}/namedTimePeriods/namedTimePeriod[2]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{ohc}/oaiSiteGroupList/oaiSiteGroup[1]/oaiCollectionPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{ohc}/oaiSiteGroupList/oaiSiteGroup[2]/oaiCollectionPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{ohc}/oaiSiteGroupList/oaiSiteGroup/oaiLocVerbatim"
        ]
        test_converter(doc, record, xpaths)
      end
      

      it "Remaps objectNameGroups correctly" do
        xpaths = [
          "/document/#{common}/objectNameList/objectNameGroup/objectNameType",
          "/document/#{common}/objectNameList/objectNameGroup/objectNameSystem",
          { xpath: "/document/#{common}/objectNameList/objectNameGroup[1]/objectName", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/objectNameList/objectNameGroup[2]/objectName", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{common}/objectNameList/objectNameGroup/objectNameCurrency",
          "/document/#{common}/objectNameList/objectNameGroup/objectNameNote",
          "/document/#{common}/objectNameList/objectNameGroup/objectNameLevel",
          { xpath: "/document/#{common}/objectNameList/objectNameGroup[1]/objectNameLanguage", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/objectNameList/objectNameGroup[2]/objectNameLanguage", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
        ]
        test_converter(doc, record, xpaths)
      end

      it "Remaps assocPeopleGroups correctly" do
        xpaths = [
          "/document/#{common}/assocPeopleGroupList/assocPeopleGroup/assocPeopleNote",
          "/document/#{common}/assocPeopleGroupList/assocPeopleGroup/assocPeopleType",
          { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[1]/assocPeople", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[1]/assocPeople", transform: ->(text) {CSURN.parse(text)[:subtype]} },
          { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[2]/assocPeople", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/assocPeopleGroupList/assocPeopleGroup[2]/assocPeople", transform: ->(text) {CSURN.parse(text)[:subtype]} },
        ]
        test_converter(doc, record, xpaths)
      end
    end #  context 'sample data row 2'
  end # describe #map

  context 'sample data row 3 - objectNumber only' do
    let(:attributes) { get_attributes_by_row('ohc', 'collectionobject_ohc_specific.csv', 3) }
    let(:ohccollectionobject) { OHCCollectionObject.new(attributes) }
    let(:doc) { get_doc(ohccollectionobject) }
    let(:record) { get_fixture('ohc_collectionobject_row3.xml') }
    let(:xpaths) {[
      "/document/*/objectNumber"
    ]}

    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

end
