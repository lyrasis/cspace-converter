require 'rails_helper'

RSpec.describe CSXML::Helpers do
  def doc(xml)
    Nokogiri::XML(xml.to_xml)
  end

  let(:xml) { Nokogiri::XML::Builder.new(:encoding => 'UTF-8') }
  let(:attributes_title_only) {{
    'title' => 'El gato!'
  }}
  let(:attributes_measured_part_group_list) {{
    'dimensionsummary' => '8.5 x 11',
    'measuredpart' => 'frame',
    'dimension' => 'height; width',
    'value' => '8.5; 11',
    'measurementunit' => 'inches',
    'measuredby' => 'Jurgen Klopp',
    'measurementmethod' => 'ruler',
    'valuedate' => '2019-12-01',
    'valuequalifier' => 'qualifier text',
    'dimensionnote' => 'note text',
  }}
  let(:attributes_pairs) {{
    'letitbe' => 'Let it Be.'
  }}
  let(:attributes_simple_groups) {{
    'simple' => 'This is a simple group value!'
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
  let(:simple_groups) {{
    'simple' => 'simple'
  }}
  let(:pairs) {{
    'letitbe' => 'letItBe'
  }}
  let(:person_name) { 'Jurgen Klopp' }
  let(:person_refname) { "urn:cspace:core.collectionspace.org:personauthorities:name(person):item:name(JurgenKlopp1289035554)'Jurgen Klopp'" }
  let(:vocab) { 'English' }
  let(:vocab_refname) { "urn:cspace:core.collectionspace.org:vocabularies:name(languages):item:name(english)'English'" }

  xit "can 'add date group' correctly" do
    # TODO
  end

  it "can 'add measured part group list' correctly" do
    CSXML::Helpers.add_measured_part_group_list(xml, attributes_measured_part_group_list)
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup/measuredPart').text).to eq('frame')
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup/dimensionSummary').text).to eq('8.5 x 11')
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup/measuredBy').text).to eq("#{person_refname}#{person_refname}")
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup[1]/dimension').text).to eq('height')
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup[1]/value').text).to eq('8.5')
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup[2]/dimension').text).to eq('width')
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup/dimensionSubGroupList/dimensionSubGroup[2]/value').text).to eq('11')
  end

  it "can 'add pairs' correctly" do
    CSXML::Helpers.add_pairs(xml, attributes_pairs, pairs)
    expect(doc(xml).xpath('/letItBe').text).to eq('Let it Be.')
  end

  it "can 'add person' correctly" do
    expect(CSXML::Helpers.add_person(xml, 'owner', nil)).to be nil
    CSXML::Helpers.add_person(xml, 'owner', person_name)
    expect(doc(xml).xpath('/owner').text).to eq(person_refname)
  end

  it "can 'add simple groups' correctly" do
    CSXML::Helpers.add_simple_groups(xml, attributes_simple_groups, simple_groups)
    expect(doc(xml).xpath('/simpleGroupList/simpleGroup/simple').text).to eq('This is a simple group value!')
  end

  xit "can 'add simple repeats' correctly" do
    # TODO
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

  it "can identify reserved field names correctly" do
    expect(CSXML::Helpers.reserved?('comment')).to be true
  end

  xit "can safe split correctly" do
    # TODO
  end

  it "can get short identifier for authority" do
    expect(CSXML::Helpers.shortid_for_auth(
      'personauthorities',
      'person',
      person_name
    )).to eq CSURN.parse(person_refname)[:identifier]
  end

  it "can get short identifier for vocabulary" do
    expect(CSXML::Helpers.shortid_for_vocab(
      'languages',
      vocab
    )).to eq CSURN.parse(vocab_refname)[:identifier]
  end
end
