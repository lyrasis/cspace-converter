require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtCollectionObject do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'publicart.collectionspace.org'
  end

  let(:attributes) { get_attributes('publicart', 'collectionobject.csv') }
  let(:pacollectionobject) { PublicArtCollectionObject.new(attributes) }
  let(:doc) { get_doc(pacollectionobject) }
  let(:record) { get_fixture('publicart_collectionobject1.xml') }

  
  describe '#map_common' do
    common = 'collectionobjects_common'
    context 'fields not included in publicart' do
      [
        "/document/#{common}/collection",
        "/document/#{common}/objectProductionDateGroupList/objectProductionDateGroup"
      ].each do |xpath|
        context "#{xpath}" do
          it 'is empty' do
            verify_field_is_empty(doc, xpath)
          end
        end
      end
    end
      
    context 'authority/vocab fields' do
      [
        "/document/#{common}/responsibleDepartments/responsibleDepartment",
        "/document/#{common}/objectNameList/objectNameGroup/objectName",
        "/document/#{common}/materialGroupList/materialGroup/material"
      ].each do |xpath|
        context "#{xpath}" do
          let(:urn_vals) { urn_values(doc, xpath) }
          it 'is not empty' do
            verify_field_is_populated(doc, xpath)
          end

          it 'values are URNs' do
            verify_values_are_urns(urn_vals)
          end
          
          it 'URNs match sample payload' do
            verify_urn_match(urn_vals, record, xpath)
          end
        end
  end
  end
  end

  describe '#map_publicart' do
    pa = 'collectionobjects_publicart'
    context 'authority/vocab fields' do
      [
        "/document/#{pa}/publicartCollections/publicartCollection",
        "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup/publicartProductionPerson",
        "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup/publicartProductionPersonRole",
        "/document/#{pa}/publicartProductionDateGroupList/publicartProductionDateGroup/publicartProductionDateType"
      ].each do |xpath|
        context "#{xpath}" do
          let(:urn_vals) { urn_values(doc, xpath) }
          it 'is not empty' do
            verify_field_is_populated(doc, xpath)
          end

          it 'values are URNs' do
            verify_values_are_urns(urn_vals)
          end
          
          it 'URNs match sample payload' do
            verify_urn_match(urn_vals, record, xpath)
          end
        end
      end
    end

    

    context 'structured date fields' do
      [
        "/document/#{pa}/publicartProductionDateGroupList/publicartProductionDateGroup/publicartProductionDate"
      ].each do |xpath|
        context "#{xpath}" do
          it 'is not empty' do
            expect(doc.xpath(xpath).size).to_not eq(0)
          end

          it 'matches sample payload' do
            expect(get_structured_date(doc, xpath)).to eq(get_structured_date(record, xpath))
          end
        end
      end
    end

    context 'non-authority/vocab fields' do
        [
        "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup/publicartProductionPersonType"
        ].each do |xpath|
          context "#{xpath}" do
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end
            
            it 'matches sample payload' do
              verify_value_match(doc, record, xpath)
            end
          end
        end
      end
  end
end
