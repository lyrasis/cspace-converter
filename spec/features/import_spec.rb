# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/import_form'

RSpec.feature 'Importing data' do
  before(:all) do
    ENV['CSPACE_CONVERTER_ASYNC_JOBS'] = 'false'
  end

  scenario 'with an invalid file' do
    result = ImportForm.new.visit_page.fill_in_with(
      file: Rails.root.join('README.md')
    ).submit
    expect(result).to have_content('Import error')
  end

  context 'acquisitions' do
    let(:params_for_acq) do
      {
        batch: 'acq1',
        profile: 'acquisition',
        file: Rails.root.join('data', 'core', 'acquisition_core_all.csv')
      }
    end
    scenario 'with an incorrect file' do
      result = ImportForm.new.visit_page.fill_in_with(
        file: Rails.root.join('data', 'core', 'group_core_all.csv')
      ).submit
      expect(result).to have_content('ERROR: missing headers: acquisitionreferencenumber')
    end
    scenario 'with a valid file' do
      result = ImportForm.new.visit_page.fill_in_with(params_for_acq).submit
      expect(result).to have_content('Check back periodically for results.')
      expect(result).to have_content(params_for_acq[:batch])
      expect(DataObject.count).to eq 32
      expect(CollectionSpaceObject.where(type: 'Acquisition').count).to eq 32
    end
  end
end
