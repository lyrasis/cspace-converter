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
    # socialMedia fields are tested in extension/social_media_spec.rb
    context 'test' do
      [
        "/document/#{pa}/organizations/organization"
      ].each do |xpath|
        context "#{xpath}" do
          it 'all values will be URNs' do
            expect(urn_values(doc, xpath)).not_to include('Not a URN')
          end
          
          it 'URNs match sample payload' do
            expect(urn_values(doc, xpath)).to eq(urn_values(record, xpath))
          end
        end
      end
    end
  end
end
