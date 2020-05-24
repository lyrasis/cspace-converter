require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Lhmc::LhmcCollectionObject do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'lhmc.collectionspace.org'
  end

  let(:common) { 'collectionobjects_common' }
  let(:lhmc) { 'collectionobjects_lhmc' }
  
  let(:attr2) { get_attributes('lhmc', 'collectionobject_partial.csv') }
  let(:co2) { LhmcCollectionObject.new(attr2) }
  let(:out2) { get_doc(co2) }
  let(:xml2) { get_fixture('lhmc_collectionobject_row2.xml') }

  let(:attr3) { get_attributes_by_row('lhmc', 'collectionobject_partial.csv', 3) }
  let(:co3) { LhmcCollectionObject.new(attr3) }
  let(:out3) { get_doc(co3) }
  let(:xml3) { get_fixture('lhmc_collectionobject_row3.xml') }
  
  describe '#map_common' do
    context 'when vocabulary or authority sources differ from core' do
      it  'maps numberType to vocab' do
        xpaths = [
          { xpath: "/document/#{common}/otherNumberList/otherNumber[1]/numberType", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/otherNumberList/otherNumber[2]/numberType", transform: ->(text) {CSURN.parse(text)[:label].downcase} }
        ]
        test_converter(out2, xml2, xpaths)
      end

      it  'maps contentPlace to correct authorities' do
        xpaths = [
          { xpath: "/document/#{common}/contentPlaces/contentPlace[1]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/contentPlaces/contentPlace[2]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },

          { xpath: "/document/#{common}/contentPlaces/contentPlace[1]", transform: ->(text) {CSURN.parse(text)[:subtype].downcase} },
          { xpath: "/document/#{common}/contentPlaces/contentPlace[2]", transform: ->(text) {CSURN.parse(text)[:subtype].downcase} },]
      test_converter(out2, xml2, xpaths)
    end

      it  'maps objectProductionPlace to correct authorities' do
        xpaths = [
          { xpath: "/document/#{common}/objectProductionPlaceGroupList/objectProductionPlaceGroup[1]/objectProductionPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/objectProductionPlaceGroupList/objectProductionPlaceGroup[2]/objectProductionPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/objectProductionPlaceGroupList/objectProductionPlaceGroup[1]/objectProductionPlace", transform: ->(text) {CSURN.parse(text)[:subtype].downcase} },
          { xpath: "/document/#{common}/objectProductionPlaceGroupList/objectProductionPlaceGroup[2]/objectProductionPlace", transform: ->(text) {CSURN.parse(text)[:subtype].downcase} },]
      test_converter(out2, xml2, xpaths)
    end
      
      it  'maps assocPlace to correct authorities' do
        xpaths = [
          { xpath: "/document/#{common}/assocPlaceGroupList/assocPlaceGroup[1]/assocPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/assocPlaceGroupList/assocPlaceGroup[2]/assocPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/assocPlaceGroupList/assocPlaceGroup[1]/assocPlace", transform: ->(text) {CSURN.parse(text)[:subtype].downcase} },
          { xpath: "/document/#{common}/assocPlaceGroupList/assocPlaceGroup[2]/assocPlace", transform: ->(text) {CSURN.parse(text)[:subtype].downcase} },]
        test_converter(out2, xml2, xpaths)
      end

      it  'maps assocPlace to correct authorities' do
        xpaths = [
          { xpath: "/document/#{common}/ownershipPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/ownershipPlace", transform: ->(text) {CSURN.parse(text)[:subtype].downcase} }
          ]
        test_converter(out2, xml2, xpaths)
        test_converter(out3, xml3, xpaths)
      end

    it  'maps numberValue properly' do
      xpaths = [
        "/document/#{common}/otherNumberList/otherNumber/numberValue"
      ]
      test_converter(out2, xml2, xpaths)
    end
    end

    context 'when core field not included in LHMC is included' do
      it 'does not output field' do
      xpath = "/document/#{common}/contentScripts/contentScript"
      expect(get_text(out2, xpath)).to be_empty
      end
    end
  end

  describe '#map_lhmc' do
    # placeholder for future tests if necessary
  end

  describe '#map_cultural_care_collectionobject' do
    # tested in /spec/collectionspace/converter/extension/cultural_care_spec.rb
  end
end
