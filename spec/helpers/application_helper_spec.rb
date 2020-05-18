require "rails_helper"

describe ApplicationHelper do
  it "returns all profiles" do
    expect(helper.profiles.count).to eq Lookup.module.registered_profiles.count
  end

  it "returns enabled profiles" do
    expect(helper.disabled_profiles).to_not include('cataloging')
  end

  it 'sets the title correctly' do
    expect(helper.set_title('Mighty Poro', nil, nil)).to eq('Mighty Poro')
    expect(helper.set_title('Mighty Poro', '', '')).to eq('Mighty Poro')
    expect(helper.set_title('Mighty Poro', 'CollectionObect', '')).to eq('Mighty Poro (CollectionObect)')
    expect(helper.set_title('Mighty Poro', 'Person', 'person')).to eq('Mighty Poro (Person / person)')
  end
end
