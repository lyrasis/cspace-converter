require 'rails_helper'

RSpec.describe CSURN do
  before(:all) do
    CacheObject.destroy_all
  end

  let(:vocab_urn) {
    "urn:cspace:core.collectionspace.org:vocabularies:name(languages):item:name(english)'English'"
  }

  it "can generate vocabulary urn when not in cache" do
    expect(
      CSURN.get_vocab_urn('languages', 'English')
    ).to eq vocab_urn
  end

  it "can parse a vocabulary refname" do
    parsed_urn = CSURN.parse(vocab_urn)
    expect(parsed_urn[:domain]).to eq 'core.collectionspace.org'
    expect(parsed_urn[:type]).to eq 'vocabularies'
    expect(parsed_urn[:subtype]).to eq 'languages'
    expect(parsed_urn[:identifier]).to eq 'english'
    expect(parsed_urn[:label]).to eq 'English'
  end

  it "can parse type from vocabulary refname" do
    expect(CSURN.parse_type(vocab_urn)).to eq 'vocabularies'
  end

  it "can parse subtype from vocabulary refname" do
    expect(CSURN.parse_subtype(vocab_urn)).to eq 'languages'
  end
end
