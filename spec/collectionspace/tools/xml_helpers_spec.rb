require 'rails_helper'

RSpec.describe CSXML::Helpers do
  def doc(xml)
    Nokogiri::XML(xml.to_xml)
  end

  let(:xml) { Nokogiri::XML::Builder.new(:encoding => 'UTF-8') }
  let(:attributes_title_only) {{
    'title' => 'El gato!'
  }}
  let(:attributes_title_with_language) {{
    'title' => 'El gato!',
    'titlelanguage' => 'Spanish',
  }}
  let(:attributes_title_with_translation) {{
    'title' => 'El gato!',
    'titlelanguage' => 'Spanish',
    'titletranslation' => 'Duck!',
    'titletranslationlanguage' => 'English',
  }}
  let(:person_name) { 'Jurgen Klopp' }
  let(:person_refname) { "urn:cspace:core.collectionspace.org:personauthorities:name(person):item:name(JurgenKlopp1289035554)'Jurgen Klopp'" }
  let(:vocab) { 'English' }
  let(:vocab_refname) { "urn:cspace:core.collectionspace.org:vocabularies:name(languages):item:name(english)'English'" }

  it "can 'add_person' correctly" do
    expect(CSXML::Helpers.add_person(xml, 'owner', nil)).to be nil
    CSXML::Helpers.add_person(xml, 'owner', person_name)
    expect(doc(xml).xpath('/owner').text).to eq(person_refname)
  end

  it "can 'add title' only correctly" do
    CSXML::Helpers.add_title(xml, attributes_title_only)
    expect(doc(xml).xpath('/titleGroupList/titleGroup/title').text).to eq('El gato!')
  end

  it "can 'add title' with language correctly" do
    CSXML::Helpers.add_title(xml, attributes_title_with_language)
    expect(doc(xml).xpath('/titleGroupList/titleGroup/title').text).to eq('El gato!')
    expect(doc(xml).xpath('/titleGroupList/titleGroup/titleLanguage').text).to match(/spanish/)
  end

  it "can 'add title' with translation correctly" do
    CSXML::Helpers.add_title(xml, attributes_title_with_translation)
    expect(doc(xml).xpath('/titleGroupList/titleGroup/title').text).to eq('El gato!')
    expect(doc(xml).xpath('/titleGroupList/titleGroup/titleLanguage').text).to match(/spanish/)
    expect(doc(xml).xpath('/titleGroupList/titleGroup/titleTranslationSubGroupList/titleTranslationSubGroup/titleTranslation').text).to eq('Duck!')
    expect(doc(xml).xpath('/titleGroupList/titleGroup/titleTranslationSubGroupList/titleTranslationSubGroup/titleTranslationLanguage').text).to match(/english/)
  end

  it "can 'add vocab' correctly" do
    expect(CSXML::Helpers.add_vocab(xml, 'language', 'languages', nil)).to be nil
    CSXML::Helpers.add_vocab(xml, 'language', 'languages', 'English')
    expect(doc(xml).xpath('/language').text).to eq(vocab_refname)
  end

  it "can 'get vocab' correctly" do
    expect(CSXML::Helpers.get_vocab('languages', nil)).to be nil
    expect(CSXML::Helpers.get_vocab('languages', 'English')).to eq(vocab_refname)
  end
end
