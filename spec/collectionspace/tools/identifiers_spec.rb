require 'rails_helper'

RSpec.describe CSIDF do
  it "returns correct authority term type when no mapping required" do
    expect(CSIDF.authority_term_type('person')).to eq 'person'
  end

  it "returns correct authority term type when mapping is required" do
    expect(CSIDF.authority_term_type('location')).to eq 'loc'
  end

  it "can convert vocabulary display values to id form with spaces and parens" do
    expect(
      CSIDF.for_option('Growing on a rock Bonsai style (Seki-joju)')
    ).to eq "growing_on_a_rock_bonsai_style_seki_joju"
  end

  it "can convert vocabulary display values to id form with spaces and slashes" do
    expect(
      CSIDF.for_option('Exhibitable/Needs no work')
    ).to eq "exhibitable_needs_no_work"
  end

  it "can convert vocabulary display values to id form with strip" do
    expect(CSIDF.for_option(' item ', true)).to eq 'item'
  end

  it "can convert vocabulary display values to id form with quotes" do
    expect(CSIDF.for_option("maker's mark")).to eq 'makers_mark'
  end
end