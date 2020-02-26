# frozen_string_literal: true

class NukeButton
  include Capybara::DSL

  def submit
    visit('/')
    accept_confirm do
      click_on('Nuke')
    end
    self
  end
end
