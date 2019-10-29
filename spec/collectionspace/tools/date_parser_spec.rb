require 'rails_helper'

RSpec.describe CSDTP do
  let(:basic_date) { '2011/11/02' }
  let(:basic_end_date) { '2011/12/05' }

  it "can return an empty date when no date provided" do
    date = CSDTP.parse(nil)
    expect(date.class).to eq CollectionSpace::Tools::StructuredDate
    expect(date.parsed_datetime).to be nil
  end

  it "can parse a basic date" do
    date = CSDTP.parse(basic_date)
    test_base_basic_date(date)
    expect(date.latest_day).to eq 1
    expect(date.latest_month).to eq 11
    expect(date.latest_year).to eq 2012
    expect(date.latest_scalar).to eq '2012-11-01T00:00:00.000Z'
  end

  it "can parse a basic date with end date" do
    date = CSDTP.parse(basic_date, basic_end_date)
    test_base_basic_date(date)
    expect(date.latest_day).to eq 5
    expect(date.latest_month).to eq 12
    expect(date.latest_year).to eq 2011
    expect(date.latest_scalar).to eq '2011-12-05T00:00:00.000Z'
  end
end
