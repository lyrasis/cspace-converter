require 'rails_helper'

RSpec.describe CSDTP do
  let(:basic_date) { '2011/11/02' }
  let(:basic_end_date) { '2011/12/05' }
  let(:ca_date) { 'ca. 1915' }
  let(:hyphenated_date) { '1905-1907' }
  let(:usa_date) { '11/02/1980' }

  it "can return an empty date when no date provided" do
    date = CSDTP.parse(nil)
    expect(date.class).to eq CollectionSpace::Tools::StructuredDate
    expect(date.parsed_datetime).to be nil
  end

  it "can parse a basic date" do
    date = CSDTP.parse(basic_date)
    test_base_basic_date(date)
    expect(date.latest_day).to eq 3
    expect(date.latest_month).to eq 11
    expect(date.latest_year).to eq 2011
    expect(date.latest_scalar).to eq '2011-11-03T00:00:00.000Z'
  end

  it "can parse a basic date with end date" do
    date = CSDTP.parse(basic_date, basic_end_date)
    test_base_basic_date(date)
    expect(date.latest_day).to eq 5
    expect(date.latest_month).to eq 12
    expect(date.latest_year).to eq 2011
    expect(date.latest_scalar).to eq '2011-12-05T00:00:00.000Z'
  end

  it "returns an empty date when given a ca date" do
    date = CSDTP.parse(ca_date)
    expect(date.class).to eq CollectionSpace::Tools::StructuredDate
    expect(date.parsed_datetime).to be nil
  end

  it "returns an empty date when given a hyphenated date" do
    date = CSDTP.parse(hyphenated_date)
    expect(date.class).to eq CollectionSpace::Tools::StructuredDate
    expect(date.parsed_datetime).to be nil
  end

  xit "can parse a US formatted date" do
    date = CSDTP.parse(usa_date)
    expect(date.earliest_day).to eq 2
    expect(date.earliest_month).to eq 11
    expect(date.earliest_year).to eq 1980
    expect(date.earliest_scalar).to eq '1980-11-02T00:00:00.000Z'
  end
end
