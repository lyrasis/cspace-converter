require 'rails_helper'

RSpec.describe CollectionSpaceObject do

  describe "initialization" do
    let(:authority_object) {
      prefab_authority_object
    }

    let(:authority_object_fingerprint) {
      Fingerprint.generate(['Person', 'person', 'Mickey Mouse'])
    }

    let(:hierarchy_object) {
      build(
        :collection_space_object,
        category: 'Relationship',
        csid: 'fake',
        identifier: 'xyz',
        identifier_field: 'csid',
        type: 'Hierarchy',
        uri: '/fake',
      )
    }

    let(:hierarchy_object_fingerprint) {
      Fingerprint.generate(['Hierarchy', 'csid', 'xyz'])
    }

    let(:procedure_object) {
      prefab_procedure_object
    }

    let(:procedure_object_fingerprint) {
      Fingerprint.generate(
        ['Acquisition', 'acquisitionReferenceNumber', '123']
      )
    }

    let(:relationship_object) {
      build(
        :collection_space_object,
        category: 'Relationship',
        csid: 'fake',
        identifier: 'xyz',
        identifier_field: 'csid',
        type: 'Relationship',
        uri: '/fake',
      )
    }

    let(:relationship_object_fingerprint) {
      Fingerprint.generate(['Relationship', 'csid', 'xyz'])
    }

    let(:vocabulary_object) {
      prefab_vocabulary_object
    }

    let(:vocabulary_object_fingerprint) {
      Fingerprint.generate(['vocabularies', 'languages', 'Danish'])
    }

    it "returns false correctly for no csid and uri check" do
      expect(authority_object.has_csid_and_uri?).to be false
    end

    it "returns true correctly for no csid and uri check" do
      expect(relationship_object.has_csid_and_uri?).to be true
    end

    it "identifies authority categories correctly" do
      expect(authority_object.is_authority?).to be true
      expect(authority_object.is_procedure?).to be false
      expect(authority_object.is_relationship?).to be false
      expect(authority_object.is_vocabulary?).to be false
    end

    it "identifies hierarchy categories correctly" do
      expect(hierarchy_object.is_authority?).to be false
      expect(hierarchy_object.is_procedure?).to be false
      expect(hierarchy_object.is_relationship?).to be true
      expect(hierarchy_object.is_vocabulary?).to be false
    end

    it "identifies procedure categories correctly" do
      expect(procedure_object.is_authority?).to be false
      expect(procedure_object.is_procedure?).to be true
      expect(procedure_object.is_relationship?).to be false
      expect(procedure_object.is_vocabulary?).to be false
    end

    it "identifies relationship categories correctly" do
      expect(relationship_object.is_authority?).to be false
      expect(relationship_object.is_procedure?).to be false
      expect(relationship_object.is_relationship?).to be true
      expect(relationship_object.is_vocabulary?).to be false
    end

    it "identifies vocabulary categories correctly" do
      expect(vocabulary_object.is_authority?).to be false
      expect(vocabulary_object.is_procedure?).to be false
      expect(vocabulary_object.is_relationship?).to be false
      expect(vocabulary_object.is_vocabulary?).to be true
    end

    it "fingerprints authority objects correctly" do
      authority_object.set_fingerprint
      expect(authority_object.fingerprint).to eq authority_object_fingerprint
    end

    it "fingerprints hierarchy objects correctly" do
      hierarchy_object.set_fingerprint
      expect(hierarchy_object.fingerprint).to eq hierarchy_object_fingerprint
    end

    it "fingerprints procedure objects correctly" do
      procedure_object.set_fingerprint
      expect(procedure_object.fingerprint).to eq procedure_object_fingerprint
    end

    it "fingerprints relationship objects correctly" do
      relationship_object.set_fingerprint
      expect(relationship_object.fingerprint).to eq relationship_object_fingerprint
    end

    it "fingerprints vocabulary objects correctly" do
      vocabulary_object.set_fingerprint
      expect(vocabulary_object.fingerprint).to eq vocabulary_object_fingerprint
    end

  end

end
