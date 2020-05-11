require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtPerson do
  let(:attributes) { get_attributes('publicart', 'authperson_publicart_all.csv') }
  let(:publicartperson) { PublicArtPerson.new(Lookup.profile_defaults('person').merge(attributes)) }
  let(:doc) { get_doc(publicartperson) }
  let(:record) { get_fixture('publicart_person.xml') }

  describe 'map_common' do
    context 'for fields not included in publicart' do
      p = 'persons_common'
      [
        "/document/#{p}/bioNote",
        "/document/#{p}/gender",
        "/document/#{p}/occupations/occupation",
        "/document/#{p}/schoolsOrStyles/schoolOrStyle",
        "/document/#{p}/groups/group",
        "/document/#{p}/nationalities/nationality",
        "/document/#{p}/nameNote"
      ].each do |xpath|
        context "for xpath: #{xpath}" do
          it 'is empty' do
            expect(get_text(doc, xpath)).to be_empty
          end
        end
      end
    end
  end

  describe 'map_publicart' do
    pa = 'persons_publicart'
    context 'test' do
    [
      { xpath: "/document/#{pa}/socialMediaGroupList/socialMediaGroup[1]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
      { xpath: "/document/#{pa}/socialMediaGroupList/socialMediaGroup[1]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
      { xpath: "/document/#{pa}/socialMediaGroupList/socialMediaGroup[2]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
      { xpath: "/document/#{pa}/socialMediaGroupList/socialMediaGroup[2]/socialMediaHandleType", transform: ->(text) { CSURN.parse(text)[:subtype].downcase } },
      "/document/#{pa}/socialMediaGroupList/socialMediaGroup/socialMediaHandle",
      { xpath: "/document/#{pa}/organizations/organization[1]", transform: ->(text) { CSURN.parse(text)[:label] } },
      { xpath: "/document/#{pa}/organizations/organization[2]", transform: ->(text) { CSURN.parse(text)[:label] } },
    ].each do |xpath|
      context "#{xpath}" do
        it 'matches sample payload' do
          expect(get_text(doc, xpath)).to eq(get_text(record, xpath))
        end
        
      end
    end
  end
end
end
