require 'rails_helper'

RSpec.describe CollectionSpace::Converter::PublicArt::PublicArtCollectionObject do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'publicart.collectionspace.org'
  end

  let(:common) { 'collectionobjects_common' }
  
  describe '#map' do
    let(:pa) { 'collectionobjects_publicart' }

    context 'given full sample data' do
      let(:attributes) { get_attributes('publicart', 'collectionobject.csv') }
      let(:pacollectionobject) { PublicArtCollectionObject.new(attributes) }
      let(:doc) { get_doc(pacollectionobject) }
      let(:record) { get_fixture('publicart_collectionobject1.xml') }


      it 'maps title fields correctly' do
        xpaths = [
          "/document/#{common}/titleGroupList/titleGroup[2]/title",
          { xpath: "/document/#{common}/titleGroupList/titleGroup[2]/titleLanguage", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{common}/titleGroupList/titleGroup[2]/titleType",
          "/document/#{common}/titleGroupList/titleGroup[2]/titleTranslationSubGroupList/titleTranslationSubGroup[2]/titleTranslation",
          { xpath: "/document/#{common}/titleGroupList/titleGroup[2]/titleTranslationSubGroupList/titleTranslationSubGroup[2]/titleTranslationLanguage", transform: ->(text) {CSURN.parse(text)[:label].downcase} }
        ]
        test_converter(doc, record, xpaths)
      end 

      it 'maps responsible department terms correctly' do
        xpaths = [
          { xpath: "/document/#{common}/responsibleDepartments/responsibleDepartment[1]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/responsibleDepartments/responsibleDepartment[2]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
        ]
        test_converter(doc, record, xpaths)
      end

      it 'maps responsible department terms to program vocab' do
        xpath = "/document/#{common}/responsibleDepartments/responsibleDepartment[1]"
        result = get_text(doc, xpath)
        expect(result).to include('vocabularies:name(program):')
      end

      it 'maps object names to worktype concepts' do
        xpath = "/document/#{common}/objectNameList/objectNameGroup[1]/objectName"
        result = get_text(doc, xpath)
        expect(result).to include('conceptauthorities:name(worktype)')
      end
      
      it 'maps materials to material concepts' do
        xpath = "/document/#{common}/materialGroupList/materialGroup[1]/material"
        result = get_text(doc, xpath)
        expect(result).to include('conceptauthorities:name(material_ca)')
        
      end

      it 'does not set overridden common fields' do
        xpaths = [
          '/document/*/collection',
          '/document/*/objectProductionDateGroupList/objectProductionDateGroup/dateEarliestScalarValue'
        ]
        xpaths.each{ |xpath|
          expect(get_text(doc, xpath)).to be_empty
        }
      end

      it 'maps publicartCollection to expected terms' do
        xpaths = [
          { xpath: "/document/#{pa}/publicartCollections/publicartCollection[1]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{pa}/publicartCollections/publicartCollection[2]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
        ]
        test_converter(doc, record, xpaths)
      end

      it 'maps publicartCollection to organization name' do
        xpath = "/document/#{pa}/publicartCollections/publicartCollection[1]"
        result = get_text(doc, xpath)
        expect(result).to include('orgauthorities:name(organization)')
      end

      it 'maps publicartProductionPerson field groups' do
        xpaths = [
          { xpath: "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup[1]/publicartProductionPersonRole", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup[2]/publicartProductionPersonRole", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup[1]/publicartProductionPerson", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup[2]/publicartProductionPerson", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup[1]/publicartProductionPersonType",
          "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup[2]/publicartProductionPersonType",
        ]
        test_converter(doc, record, xpaths)
      end

      it 'maps publicartProductionPerson to organization name if from column for org names' do
        xpath = "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup[2]/publicartProductionPerson"
        result = get_text(doc, xpath)
        expect(result).to include('orgauthorities:name(organization)')
      end

      it 'maps publicartProductionPerson to person name if from column for person names' do
        xpath = "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup[1]/publicartProductionPerson"
        result = get_text(doc, xpath)
        expect(result).to include('personauthorities:name(person)')
      end

      it 'maps publicartProductionPersonRole to prodpersonrole vocab' do
        xpath = "/document/#{pa}/publicartProductionPersonGroupList/publicartProductionPersonGroup[1]/publicartProductionPersonRole"
        result = get_text(doc, xpath)
        expect(result).to include('vocabularies:name(prodpersonrole)')
      end

      it 'maps publicartProductionDate field groups' do
        xpaths = [
          { xpath: "/document/#{pa}/publicartProductionDateGroupList/publicartProductionDateGroup[1]/publicartProductionDateType", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{pa}/publicartProductionDateGroupList/publicartProductionDateGroup[2]/publicartProductionDateType", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{pa}/publicartProductionDateGroupList/publicartProductionDateGroup[1]/publicartProductionDate/dateDisplayDate",
          "/document/#{pa}/publicartProductionDateGroupList/publicartProductionDateGroup[2]/publicartProductionDate/dateDisplayDate",
        ]
        test_converter(doc, record, xpaths)
      end

      it 'maps publicartProductionDateType to proddatetype vocab' do
        xpath = "/document/#{pa}/publicartProductionDateGroupList/publicartProductionDateGroup[1]/publicartProductionDateType"
        result = get_text(doc, xpath)
        expect(result).to include('vocabularies:name(proddatetype)')
      end

    end # context 'given full sample data'
  end # describe #map

end
