require 'rails_helper'

RSpec.describe DataObject do
  describe "initialization" do
    let(:data_object_no_profile) {
      build(:data_object, converter_profile: nil)
    }

    let(:data_object_bad_profile) {
      build(:data_object, converter_profile: 'y')
    }

    let(:data_object_ok) {
      build(:data_object)
    }

    it "requires a converter profile" do
      expect(data_object_no_profile).to be_invalid
      expect(data_object_bad_profile).to be_invalid
      expect(data_object_ok).to be_valid
    end

    it "requires the converter module and profile to exist" do
      expect(data_object_ok).to be_valid
    end

    it "has the converter class" do
      expect(data_object_ok.converter_class).to eq Lookup.converter_class
    end

    it "has the converter module" do
      data_object_ok.save
      expect(data_object_ok.converter_module).to eq Lookup.converter_module
    end
  end

  describe "adding cspace records" do
    let(:csid) { '123' }
    let(:data_object) {
      build(:data_object)
    }
    let(:type) { 'CollectionObject' }

    let(:relationship_data) {
      {
        title: '123-456',
        identifier: '123-456',
        subject_csid: '123',
        object_csid: '456'
      }
    }

    let(:relationship_content_data) {
      {
        'subjectcsid' => '123',
        'subjectdocumenttype' => 'Group',
        'objectcsid' => '456',
        'objectdocumenttype' => 'CollectionObject'
      }
    }
    let(:subtype) { 'object' }

    it "can find a cspace object csid" do
      CollectionSpaceObject.stub(:find_csid) { csid }
      RemoteActionService.stub(:find_item_csid)
      result = data_object.find_csid(csid, type)
      expect(result).to eq csid
      expect(CollectionSpaceObject).to have_received(
        :find_csid
      ).with(type, csid)
      expect(RemoteActionService).to_not have_received(:find_item_csid)
    end

    it "can find a remote object csid" do
      RemoteActionService.stub(:find_item_csid) { csid }
      result = data_object.find_csid(csid, type)
      expect(result).to eq csid
      expect(RemoteActionService).to have_received(
        :find_item_csid
      )
    end

    it "can abort find using subtype" do
      AuthCache.stub(:authority) { nil }
      result = data_object.find_csid(csid, type, subtype)
      expect(result).to be nil
      expect(AuthCache).to have_received(
        :authority
      ).with(type.pluralize.downcase, subtype, csid)
    end

    it "can proceed with find using subtype" do
      AuthCache.stub(:authority) { '123' }
      CollectionSpaceObject.stub(:find_csid) { csid }
      result = data_object.find_csid(csid, type, subtype)
      expect(result).to eq csid
      expect(AuthCache).to have_received(
        :authority
      ).with(type.pluralize.downcase, subtype, csid)
    end

    it "can prepare a relationship cspace object" do
      data_object.stub(:add_cspace_object)
      csids = {
        subject: { id: '123', type: 'Group' },
        object: { id: '456', type: 'CollectionObject' }
      }
      data_object.prepare_rlshp({}, csids[:subject], csids[:object])
      expect(data_object).to have_received(:add_cspace_object).with(
        relationship_data, relationship_content_data
      )
    end
  end
end
