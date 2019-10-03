require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Default::Record do

  describe "Services" do
    let(:authority_object) {
      prefab_authority_object
    }

    let(:procedure_object) {
      prefab_procedure_object
    }

    it "returns the authority person service correctly" do
      expect(
        Lookup.record_class(
          authority_object.type
        ).service(authority_object.subtype)[:id]
      ).to eq 'personauthorities'
    end

    it "returns the procedure acquisitions service correctly" do
      expect(
        Lookup.record_class(
          procedure_object.type
        ).service[:id]
      ).to eq 'acquisitions'
    end

  end

end