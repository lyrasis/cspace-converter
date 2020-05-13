# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/transfer_form'

RSpec.feature 'Transferring data' do
  include Capybara::DSL

  before(:all) do
    create(:batch, name: 'good1', succeeded: 1)
    create(:batch, name: 'bad1', succeeded: 0)
  end

  scenario 'can select a batch with successes' do
    TransferForm.new.visit_page
    expect(page).to have_css('option', text: 'good1')
  end

  scenario 'cannot select a batch with no successes' do
    TransferForm.new.visit_page
    expect(page).not_to have_css('option', text: 'bad1')
  end

  scenario 'with no batch selected', js: true do
    TransferForm.new.visit_page.fill_in_with({}).submit
    message = find('#batch').native.attribute('validationMessage')
    expect(current_path).to eq '/transfer'
    expect(message).to have_content('Please select an item')
  end

  scenario 'with no type selected', js: true do
    TransferForm.new.visit_page.fill_in_with({ batch: 'good1' }).submit
    message = find('#type').native.attribute('validationMessage')
    expect(current_path).to eq '/transfer'
    expect(message).to have_content('Please select an item')
  end
end
