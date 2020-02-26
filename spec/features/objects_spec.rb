# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/nuke_button'

RSpec.feature 'Objects page' do
  scenario 'without data', js: true do
    allow_any_instance_of(RemoteActionable).to receive(:reset_cache).and_return(nil)
    NukeButton.new.submit
    visit('/objects')
    expect(page).to have_content('No objects found')
  end
end
