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
end
