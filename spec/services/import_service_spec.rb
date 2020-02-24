# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportService::Base do
  let(:batch) { 'test1' }
  let(:profile) { 'cataloging' }
  let(:data) do
    prefab_data.merge(converter_profile: profile, import_batch: batch)
  end

  it 'can create a dataobject' do
    service = ImportService::Base.new(data)
    service.create_object
    expect(DataObject.where(data).count).to eq 1
  end

  it 'cannot process from base' do
    service = ImportService::Base.new(data)
    expect { service.process }.to raise_error
  end
end
