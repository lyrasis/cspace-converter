require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Anthro::AnthroCollectionObject do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'anthro.collectionspace.org'
  end

  let(:common) { 'collectionobjects_common' }
  
  describe '#map' do
    let(:anthro) { 'collectionobjects_anthro' }

    context 'sample data row 2' do
      let(:attributes) { get_attributes('anthro', 'collectionobject_partial.csv') }
      let(:anthrocollectionobject) { AnthroCollectionObject.new(attributes) }
      let(:doc) { get_doc(anthrocollectionobject) }
      let(:record) { get_fixture('anthro_collectionobject_2.xml') }

      it "Maps localityGroupList correctly" do
        xpaths = [
          { xpath: "/document/#{anthro}/localityGroupList/localityGroup/fieldLocPlace", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{anthro}/localityGroupList/localityGroup/fieldLocCounty",
          "/document/#{anthro}/localityGroupList/localityGroup/fieldLocState",
          "/document/#{anthro}/localityGroupList/localityGroup/localityNote",
        ]
        test_converter(doc, record, xpaths)
      end

      it "Maps commingledRemainsGroupList correctly" do
        xpaths = [
          { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[1]/ageRange", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[2]/ageRange", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[1]/behrensmeyerUpper", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[2]/behrensmeyerUpper", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[1]/behrensmeyerSingleLower", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[2]/behrensmeyerSingleLower", transform: ->(text) {CSURN.parse(text)[:label].downcase} },    
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/commingledRemainsNote",
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/sex",
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/count",
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/minIndividuals",
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/dentition",
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/bone",
          { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[1]/mortuaryTreatmentGroupList/mortuaryTreatmentGroup[1]/mortuaryTreatment", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[1]/mortuaryTreatmentGroupList/mortuaryTreatmentGroup[2]/mortuaryTreatment", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[2]/mortuaryTreatmentGroupList/mortuaryTreatmentGroup[1]/mortuaryTreatment", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup[2]/mortuaryTreatmentGroupList/mortuaryTreatmentGroup[2]/mortuaryTreatment", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{anthro}/commingledRemainsGroupList/commingledRemainsGroup/mortuaryTreatmentGroupList/mortuaryTreatmentGroup/mortuaryTreatmentNote"
        ]
        test_converter(doc, record, xpaths)
      end

      it 'Maps overrides to objectProductionPeopleGroupList' do
        xpaths = [
          { xpath: "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup[1]/objectProductionPeople", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup[1]/objectProductionPeopleRole", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup[2]/objectProductionPeople", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup[2]/objectProductionPeopleRole", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          ]
        test_converter(doc, record, xpaths)
      end

      it 'Maps overrides to objectProductionPeople from Ethno column to concept: ethculture' do
        xpath = "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup[1]/objectProductionPeople"
        result = get_text(doc, xpath)
        expect(result).to include('conceptauthorities:name(ethculture)')
      end
      it 'Maps overrides to objectProductionPeople from Arch column to concept: archculture' do
        xpath = "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup[2]/objectProductionPeople"
        result = get_text(doc, xpath)
        expect(result).to include('conceptauthorities:name(archculture)')
      end 
      it 'Maps overrides to objectProductionPeopleRole to vocab: prodpeoplerole' do
        xpath = "/document/#{common}/objectProductionPeopleGroupList/objectProductionPeopleGroup[2]/objectProductionPeopleRole"
        result = get_text(doc, xpath)
        expect(result).to include('vocabularies:name(prodpeoplerole)')
      end
     
    end #  context 'sample data row 2'
  end # describe #map

  describe '#map_annotation' do
    let(:annotation) { 'collectionobjects_annotation' }

    context 'sample data row 2' do
      let(:attributes) { get_attributes('anthro', 'collectionobject_partial.csv') }
      let(:annotationcollectionobject) { AnthroCollectionObject.new(attributes) }
      let(:doc) { get_doc(annotationcollectionobject) }
      let(:record) { get_fixture('anthro_collectionobject_2.xml') }
      let(:xpaths) {[
        "/document/#{annotation}/annotationGroupList/annotationGroup/annotationNote",
        { xpath: "/document/#{annotation}/annotationGroupList/annotationGroup[1]/annotationType", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
        { xpath: "/document/#{annotation}/annotationGroupList/annotationGroup[2]/annotationType", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
        "/document/#{annotation}/annotationGroupList/annotationGroup/annotationDate",
        { xpath: "/document/#{annotation}/annotationGroupList/annotationGroup[1]/annotationAuthor", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
        { xpath: "/document/#{annotation}/annotationGroupList/annotationGroup[2]/annotationAuthor", transform: ->(text) {CSURN.parse(text)[:label].downcase} }
      ]}

      it "Maps attributes correctly" do
        test_converter(doc, record, xpaths)
      end
    end #  context 'sample data row 2'
  end # describe #map

    describe '#map_nagpra' do
      let(:nagpra) { 'collectionobjects_nagpra' }

      context 'sample data row 2' do
        let(:attributes) { get_attributes('anthro', 'collectionobject_partial.csv') }
        let(:annotationcollectionobject) { AnthroCollectionObject.new(attributes) }
        let(:doc) { get_doc(annotationcollectionobject) }
        let(:record) { get_fixture('anthro_collectionobject_2.xml') }
        let(:xpaths) {[
          "/document/#{nagpra}/nagpraReportFiled",
          { xpath: "/document/#{nagpra}/nagpraReportFiledBy", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{nagpra}/repatriationNotes/repatriationNote",
          { xpath: "/document/#{nagpra}/nagpraCategories/nagpraCategory[1]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          { xpath: "/document/#{nagpra}/nagpraCategories/nagpraCategory[2]", transform: ->(text) {CSURN.parse(text)[:label].downcase} },
          "/document/#{nagpra}/nagpraReportFiledDate/dateLatestScalarValue",
          "/document/#{nagpra}/nagpraReportFiledDate/dateEarliestScalarValue"          
        ]}

        it "Maps attributes correctly" do
          test_converter(doc, record, xpaths)
        end
      end #  context 'sample data row 2'

      context 'sample data row 7 - objectNumber only' do
        let(:attributes) { get_attributes_by_row('anthro', 'collectionobject_partial.csv', 7) }
        let(:anthrocollectionobject) { AnthroCollectionObject.new(attributes) }
        let(:doc) { get_doc(anthrocollectionobject) }
        let(:record) { get_fixture('anthro_collectionobject_row7.xml') }
        let(:xpaths) {[
          "/document/*/objectNumber"
        ]}

        it "Maps attributes correctly" do
          test_converter(doc, record, xpaths)
        end
      end
    end # describe #map

  
end
