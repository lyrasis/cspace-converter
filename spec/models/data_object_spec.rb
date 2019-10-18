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
  end
end
