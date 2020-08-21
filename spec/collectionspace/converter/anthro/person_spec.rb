require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Anthro::AnthroPerson do
  let(:attributes) { get_attributes('anthro', 'person.csv') }
  let(:aperson) { AnthroPerson.new(Lookup.profile_defaults('person').merge(attributes)) }
  let(:doc) { get_doc(aperson) }
  let(:record) { get_fixture('anthro_person.xml') }
  before(:all) do
  @p = 'persons_common'
  @pa = 'persons_anthro'
  @cc = 'contacts_common'
  end
  
  describe '#map_common' do
    context 'authority/vocab fields' do
      [
        "/document/#{@pa}/personRecordTypes/personRecordType"
      ].each do |xpath|
        context "#{xpath}" do
          let(:urn_vals) { urn_values(doc, xpath) }
          it 'is not empty' do
            verify_field_is_populated(doc, xpath)
          end

          it 'values are URNs' do
            verify_values_are_urns(urn_vals)
          end

          it 'URNs match sample payload' do
            verify_urn_match(urn_vals, record, xpath)
          end
        end
      end
    end

    context 'regular fields' do
      [
        "/document/#{@p}/personTermGroupList/personTermGroup/termDisplayName",
        "/document/#{@p}/personTermGroupList/personTermGroup/termType",
        "/document/#{@cc}/addressGroupList/addressGroup/addressCountry",
        "/document/#{@cc}/addressGroupList/addressGroup/addressMunicipality",
      ].each do |xpath|
        context "#{xpath}" do
          it 'is not empty' do
            verify_field_is_populated(doc, xpath)
          end

          it 'matches sample payload' do
            verify_value_match(doc, record, xpath)
          end
        end
      end
    end
  end
end
