class ImportForm
  include Capybara::DSL

  def visit_page
    visit('/import')
    self
  end

  def fill_in_with(params = {})
    within('#import') do
      fill_in('Batch', with: params.fetch(:batch, 'example1'))
      select params.fetch(:profile, 'acquisition')
      attach_file 'File', params.fetch(:file, nil)
    end
    self
  end

  def submit
    click_on('Upload')
    self
  end

end