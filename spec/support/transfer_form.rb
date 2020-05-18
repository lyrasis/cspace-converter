# frozen_string_literal: true

class TransferForm
  include Capybara::DSL

  def visit_page
    visit('/transfer')
    self
  end

  def fill_in_with(params = {})
    within('#transfer') do
      choose(params.fetch(:remote_action, 'Transfer'))
      select params.fetch(:batch, nil)
      select params.fetch(:type, nil)
    end
    self
  end

  def submit
    click_on('Process')
    self
  end
end
