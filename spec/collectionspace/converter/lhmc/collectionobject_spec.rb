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
  let(:cc) { 'collectionobjects_culturalcare' }
  
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
      it  'overrides different vocabulary and authority sources' do
      end
    end

    context 'when core field not included in LHMC is included' do
      it 'does not output field' do
      end
    end
  end

  describe '#map_lhmc' do
    # placeholder for future tests if necessary
  end

  describe '#map_cultural_care' do
    it "Maps culturalCareNote correctly" do
      xpaths = [
        "/document/#{cc}/culturalCareNotes/culturalCareNote"
      ]
      test_converter(out2, xml2, xpaths)
    end

    it "Maps limitationDetails correctly" do
      xpaths = [
        "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/limitationDetails"
      ]
      test_converter(out2, xml2, xpaths)
    end
    
    it "Maps limitationLevel correctly" do
      xpaths = [
      { xpath: "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup[1]/limitationLevel", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup[2]/limitationLevel", transform: ->(text) {CSURN.parse(text)[:label].downcase} }
      ]
      test_converter(out2, xml2, xpaths)
    end

    it "Maps limitationType correctly" do
      xpaths = [
      { xpath: "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup[1]/limitationType", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup[2]/limitationType", transform: ->(text) {CSURN.parse(text)[:label].downcase} }
      ]
      test_converter(out2, xml2, xpaths)
    end

    it "Maps requestDate correctly" do
      xpaths = [
      "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup/requestDate"
      ]
      test_converter(out2, xml2, xpaths)
    end

    it "Maps requester correctly" do
      xpaths = [
      { xpath: "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup[1]/requester", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup[2]/requester", transform: ->(text) {CSURN.parse(text)[:label].downcase} }
      ]
      test_converter(out2, xml2, xpaths)
    end

    it "Maps requestOnBehalfOf correctly" do
      xpaths = [
      { xpath: "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup[1]/requestOnBehalfOf", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
      { xpath: "/document/#{cc}/accessLimitationsGroupList/accessLimitationsGroup[2]/requestOnBehalfOf", transform: ->(text) {CSURN.parse(text)[:label].downcase} }
      ]
      test_converter(out2, xml2, xpaths)
    end

  end
end
