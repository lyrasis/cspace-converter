require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Extension::NaturalHistory do
  let(:attributes) { get_attributes('extension', 'naturalhistory_collectionobject.csv') }
  let(:co) { AnthroCollectionObject.new(attributes) }
  let(:codoc) { get_doc(co) }
  let(:corecord) { get_fixture('ext_naturalhistory_collectionobject.xml') }

  describe '#map_natural_history_collectionobject' do
    cc = 'collectionobjects_naturalhistory_extension'

    context 'authority/vocab fields' do
      [
        "/document/#{cc}/taxonomicIdentGroupList/taxonomicIdentGroup/taxon",
        "/document/#{cc}/taxonomicIdentGroupList/taxonomicIdentGroup/qualifier",
        "/document/#{cc}/taxonomicIdentGroupList/taxonomicIdentGroup/identBy",
        "/document/#{cc}/taxonomicIdentGroupList/taxonomicIdentGroup/institution",
        "/document/#{cc}/taxonomicIdentGroupList/taxonomicIdentGroup/identKind",
      ].each do |xpath|
        context xpath.to_s do
          let(:urn_vals) { urn_values(codoc, xpath) }
          it 'is not empty' do
            verify_field_is_populated(codoc, xpath)
          end

          it 'values are URNs' do
            verify_values_are_urns(urn_vals)
          end

          it 'URNs match sample payload' do
            verify_urn_match(urn_vals, corecord, xpath)
          end
        end
      end
    end

    context 'structured date fields' do
      [
        "/document/#{cc}/taxonomicIdentGroupList/taxonomicIdentGroup/identDateGroup"
      ].each do |xpath|
        context xpath.to_s do
          it 'is not empty' do
            expect(codoc.xpath(xpath).size).to_not eq(0)
          end

          it 'matches sample payload' do
            expect(get_structured_date(codoc, xpath)).to eq(get_structured_date(corecord, xpath))
          end
        end
      end
    end
    context 'regular fields' do
        [
          "/document/#{cc}/taxonomicIdentGroupList/taxonomicIdentGroup/reference",
          "/document/#{cc}/taxonomicIdentGroupList/taxonomicIdentGroup/refPage",
          "/document/#{cc}/taxonomicIdentGroupList/taxonomicIdentGroup/notes"
        ].each do |xpath|
          context xpath.to_s do
            it 'is not empty' do
              verify_field_is_populated(codoc, xpath)
            end

            it 'matches sample payload' do
              verify_value_match(codoc, corecord, xpath)
            end
          end
        end
      end
  end
end
