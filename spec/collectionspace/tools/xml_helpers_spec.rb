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
  let(:date) { CSDTP.parse('2015-06-07') }

  it "can 'add measured part group list' correctly" do
    CSXML::Helpers.add_measured_part_group_list(xml, attributes_measured_part_group_list)
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup/measuredPart').text).to eq('frame')
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup[1]/dimensionSummary').text).to eq('8.5 x 11')
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup[1]/dimensionSubGroupList/dimensionSubGroup/measuredBy').text).to eq(person_refname)
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup[1]/dimensionSubGroupList/dimensionSubGroup/dimension').text).to eq('height')
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup[1]/dimensionSubGroupList/dimensionSubGroup/value').text).to eq('8.5')
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup[2]/dimensionSubGroupList/dimensionSubGroup/dimension').text).to eq('width')
    expect(doc(xml).xpath('/measuredPartGroupList/measuredPartGroup[2]/dimensionSubGroupList/dimensionSubGroup/value').text).to eq('11')
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

  describe '#mvfs_even?' do
    let(:fghash1) { {
      'a' => {:values => ['9 - 10', '10 - 11', '11 - 12'], :field => 'fieldName'},
      'b' => {:values => %w[cat bat rat], :field => 'fieldName'},	
      'c' => {:values => %w[goat moat stoat], :field => 'fieldName'}
    } }
    let(:fghash2) { {
      'a' => {:values => ['9 - 10', '10 - 11', '11 - 12'], :field => 'fieldName'},
      'b' => {:values => %w[cat bat rat ghat], :field => 'fieldName'},
      'c' => {:values => %w[goat moat stoat], :field => 'fieldName'}
    } }

    it 'returns true if equal number of values in fieldGroup fields' do
      expect(CSXML::Helpers.mvfs_even?(fghash1)).to be true
    end

    it 'returns false if unequal number of values in fieldGroup fields' do
      expect(CSXML::Helpers.mvfs_even?(fghash2)).to be false
    end
  end

  describe '#flatten_mvfs' do
    let(:fghash1) { {
      'z' => {:values => [], :field => 'noField'},
      'a' => {:values => ['9 - 10', '10 - 11', ''], :field => 'fieldOne'},
      'aa' => {:values => ['', '', '11 - 12'], :field => 'fieldOne'},
      'b' => {:values => %w[cat bat rat], :field => 'fieldTwo'},	
      'c' => {:values => %w[goat moat stoat], :field => 'fieldThree'},
      'd' => {:values => ['', 'v1', 'v2'], :field => 'fieldFour'}
    } }
    let(:result) { [
      {'fieldOne' => '9 - 10', 'fieldTwo' => 'cat', 'fieldThree' => 'goat', 'fieldFour' => ''},
      {'fieldOne' => '10 - 11', 'fieldTwo' => 'bat', 'fieldThree' => 'moat', 'fieldFour' => 'v1'},
      {'fieldOne' => '11 - 12', 'fieldTwo' => 'rat', 'fieldThree' => 'stoat', 'fieldFour' => 'v2'},
    ]}

    it 'flattens fieldgroup hash properly' do
      expect(CSXML::Helpers.flatten_mvfs(fghash1)).to eq(result)
    end
  end

  describe '#multicolumn_fields' do
    it 'returns array of multicolumn field names present' do
      h = {
        'a' => {:values => ['9 - 10', '10 - 11', ''], :field => 'fieldOne'},
        'aa' => {:values => ['', '', '11 - 12'], :field => 'fieldOne'},
        'b' => {:values => %w[cat bat rat], :field => 'fieldTwo'},	
        'bb' => {:values => %w[cat bat rat], :field => 'fieldTwo'},
        'bbb' => {:values => %w[cat bat rat], :field => 'fieldTwo'},
        'c' => {:values => %w[goat moat stoat], :field => 'fieldThree'},
      }
      expect(CSXML::Helpers.multicolumn_fields(h)).to eq(['fieldOne', 'fieldTwo'])
    end

    it 'returns empty array if no multicolumn fields present' do
      h = {
        'a' => {:values => ['9 - 10', '10 - 11', ''], :field => 'fieldOne'},
        'b' => {:values => %w[cat bat rat], :field => 'fieldTwo'},	
        'c' => {:values => %w[goat moat stoat], :field => 'fieldThree'},
      }
      expect(CSXML::Helpers.multicolumn_fields(h)).to eq([])
    end
  end


  describe '#apply_transforms' do
    let(:transforms) { {
      'a' => {'replace' => [{ 'find' => ' - ',
                              'replace' => '-',
                              'type' => 'plain' }],
              'vocab' => 'agerange'
             },
      'b' => {'replace' => [{ 'find' => '[bc]at',
                              'replace' => 'batcat',
                              'type' => 'regexp' },
                            { 'find' => 'batcat batcat',
                              'replace' => 'batcats',
                              'type' => 'plain' }],
              'authority' => ['placeauthorities', 'place']
             },
      'c' => {'replace' => [{'find' => '^goat *(\d+)',
                              'replace' => 'caprine \1',
                              'type' => 'regexp'}]
             },
      'd' => {'special' => 'unstructured_date_string'},
      'dd' => {'special' => 'unstructured_date_stamp'},
      'ddd' => {'special' => 'structured_date'},
      'e' => {'special' => 'boolean' },
      'f' => {'special' => 'behrensmeyer_translate',
              'vocab' => 'behrensmeyer'
             },
      'g' => {'special' => 'upcase_first_char'},
      'h' => {'special' => 'downcase_first_char'}
    } }

    let(:resa) { CSXML::Helpers.apply_transforms(transforms, 'a', '9 - 10') }
    let(:resb) { CSXML::Helpers.apply_transforms(transforms, 'b', 'cat bat rat sat') }
    let(:resc) { CSXML::Helpers.apply_transforms(transforms, 'c', 'goat123') }
    let(:resd) { CSXML::Helpers.apply_transforms(transforms, 'd', '9/9/1999') }
    let(:resdd) { CSXML::Helpers.apply_transforms(transforms, 'dd', '9/9/1999') }
    let(:resddd) { CSXML::Helpers.apply_transforms(transforms, 'ddd', '2011-11-02') }
    let(:rese) { CSXML::Helpers.apply_transforms(transforms, 'e', 'True') }
    let(:resf) { CSXML::Helpers.apply_transforms(transforms, 'f', '3') }
    let(:b_urn) { CSXML::Helpers.get_vocab('behrensmeyer', CSXML::Helpers.behrensmeyer_translate('3')) }
    let(:resg) { CSXML::Helpers.apply_transforms(transforms, 'g', 'bear') }
    let(:resh) { CSXML::Helpers.apply_transforms(transforms, 'h', 'Bear') }

    let(:structured_date_fields) {
      {"scalarValuesComputed"=>"true",
       "dateDisplayDate"=>"2011-11-02",
       "dateEarliestSingleYear"=>2011,
       "dateEarliestSingleMonth"=>11,
       "dateEarliestSingleDay"=>2,
       "dateEarliestScalarValue"=>"2011-11-02T00:00:00.000Z",
       "dateEarliestSingleEra"=>
         "urn:cspace:core.collectionspace.org:vocabularies:name(dateera):item:name(ce)'CE'",
       "dateLatestYear"=>2011,
       "dateLatestMonth"=>11,
       "dateLatestDay"=>3,
       "dateLatestScalarValue"=>"2011-11-03T00:00:00.000Z",
       "dateLatestEra"=>
         "urn:cspace:core.collectionspace.org:vocabularies:name(dateera):item:name(ce)'CE'"}
    }
    
    it 'applies transforms properly' do
      expect(resa).to include('9-10')
      expect(resa).to include(':vocabularies:name(agerange):')
      expect(resb).to include('batcats rat sat')
      expect(resb).to include(':placeauthorities:name(place):')
      expect(resc).to eq('caprine 123')
      expect(resd).to eq('1999-09-09')
      expect(resdd).to eq('1999-09-09T00:00:00.000Z')
      expect(resddd).to eq(structured_date_fields)
      expect(rese).to eq('true')
      expect(resf).to eq(b_urn)
      expect(resg).to eq('Bear')
      expect(resh).to eq('bear')
    end
    
  end
  
  describe '#behrensmeyer_translate' do
    context 'when value is a number in Behrensmeyer scale' do
      it 'returns full Behrensmeyer value' do
        expect(CSXML::Helpers.behrensmeyer_translate('3')).to eq('3 - fibrous texture, extensive exfoliation')
      end
    end
    context 'when value is anything else' do
      it 'returns original value' do
        expect(CSXML::Helpers.behrensmeyer_translate('nope')).to eq('nope')
      end
    end
  end

  describe '#to_boolean' do
    it 'returns true if value = True' do
      expect(CSXML::Helpers.to_boolean('True')).to eq('true')
    end
    it 'returns true if value = y' do
      expect(CSXML::Helpers.to_boolean('y')).to eq('true')
    end
    it 'returns false if value = empty string' do
      expect(CSXML::Helpers.to_boolean('')).to eq('false')
    end
  end

  describe '#add_date_group' do
    context 'when suffix argument not given' do
      it "adds date group with 'Group' suffix" do
        CSXML::Helpers.add_date_group(xml, 'testDate', date)
        expect(doc(xml).xpath('/testDateGroup/dateDisplayDate').text).to eq('2015-06-07')
        expect(doc(xml).xpath('/testDateGroup/dateEarliestSingleYear').text).to eq('2015')
      end
    end
    context 'when suffix argument given as empty string' do
      it "adds date group with no suffix" do
        CSXML::Helpers.add_date_group(xml, 'testDate', date, '')
        expect(doc(xml).xpath('/testDate/dateDisplayDate').text).to eq('2015-06-07')
        expect(doc(xml).xpath('/testDate/dateEarliestSingleYear').text).to eq('2015')
      end
    end
  end

  describe '#add_date_group_list' do
  end
  
end
