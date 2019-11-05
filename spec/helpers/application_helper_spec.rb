require "spec_helper"

describe ApplicationHelper do
  it "returns all profiles" do
    expect(helper.profiles.count).to eq Lookup.converter_class.registered_profiles.count
  end

  it "returns enabled profiles" do
    expect(helper.disabled_profiles).to_not include('cataloging')
  end
end
