require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Anthro::AnthroOsteology do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'anthro.collectionspace.org'
  end

  let(:anthroosteology) { AnthroOsteology.new(attributes) }
  let(:p) { 'osteology_common' }
  let(:ext) { 'osteology_anthropology' }

  context 'with full sample data' do
    let(:attributes) { get_attributes('anthro', 'osteology_anthro_all.csv') }
    let(:doc) { get_doc(anthroosteology) }
    let(:record) { get_fixture('anthro_osteology.xml') }
    let(:xpaths) {[
      "/document/#{p}/InventoryID",
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateVerbatim",
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateLower",
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateUpper",
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateDisplayDate",
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateEarliestScalarValue",
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateLatestScalarValue",
      { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[1]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
      { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[2]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateNote",
      "/document/#{p}/sexDeterminationGroupList/sexDeterminationGroup/sexDetermination",
      "/document/#{p}/sexDeterminationGroupList/sexDeterminationGroup/sexDeterminationDateGroup/dateDisplayDate",
      "/document/#{p}/sexDeterminationGroupList/sexDeterminationGroup/sexDeterminationDateGroup/dateEarliestScalarValue",
      "/document/#{p}/sexDeterminationGroupList/sexDeterminationGroup/sexDeterminationDateGroup/dateLatestScalarValue",
      { xpath: "/document/#{p}/sexDeterminationGroupList/sexDeterminationGroup[1]/sexDeterminationAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
      { xpath: "/document/#{p}/sexDeterminationGroupList/sexDeterminationGroup[2]/sexDeterminationAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{p}/sexDeterminationGroupList/sexDeterminationGroup/sexDeterminationNote",
      { xpath: "/document/#{p}/completeness", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{p}/completenessNote",
      "/document/#{p}/molarsPresent",
      { xpath: "/document/#{p}/dentitionScore", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{p}/dentitionNote",
      { xpath: "/document/#{p}/mortuaryTreatment", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{p}/mortuaryTreatmentNote",
      { xpath: "/document/#{p}/behrensmeyerSingleLower", transform: ->(text) { CSURN.parse(text)[:label] } },
      { xpath: "/document/#{p}/behrensmeyerUpper", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{p}/NotesOnElementInventory",
      "/document/#{p}/pathologyNote",
      "/document/#{p}/InventoryIsComplete",
      { xpath: "/document/#{p}/inventoryAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{p}/inventoryDate",
      "/document/#{ext}/Notes_DentalPathology",
      "/document/#{ext}/Notes_CranialPathology",
      "/document/#{ext}/Notes_PostcranialPathology",
      "/document/#{ext}/Notes_CulturalModifications",
      "/document/#{ext}/Notes_NHTaphonomicAlterations",
      "/document/#{ext}/Notes_CuratorialSuffixing",
      "/document/#{ext}/cranialDeformationPresent",
      { xpath: "/document/#{ext}/cranialDeformationCategories/cranialDeformationCategory", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{ext}/cranialDeformationNote",
      "/document/#{ext}/trepanationPresent",
      "/document/#{ext}/trepanationGroupList/trepanationGroup/trepanationLocation",
      { xpath: "/document/#{ext}/trepanationGroupList/trepanationGroup[1]/trepanationCertainty", transform: ->(text) { CSURN.parse(text)[:label] } },
      { xpath: "/document/#{ext}/trepanationGroupList/trepanationGroup[2]/trepanationCertainty", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{ext}/trepanationGroupList/trepanationGroup/trepanationDimensionMax",
      "/document/#{ext}/trepanationGroupList/trepanationGroup/trepanationDimensionMin",
      { xpath: "/document/#{ext}/trepanationGroupList/trepanationGroup/trepanationTechnique", transform: ->(text) { CSURN.parse(text)[:label] } },
      { xpath: "/document/#{ext}/trepanationGroupList/trepanationGroup[1]/trepanationHealing", transform: ->(text) { CSURN.parse(text)[:label] } },
      { xpath: "/document/#{ext}/trepanationGroupList/trepanationGroup[2]/trepanationHealing", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{ext}/trepanationGroupList/trepanationGroup/trepanationNote",
      "/document/#{ext}/trepanationGeneralNote",
    ]}

    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end #context with full sample data

    context 'without verbatim age column' do
    let(:attributes) { get_attributes('anthro', 'osteology_anthro_sparse1.csv') }
    let(:doc) { get_doc(anthroosteology) }
    let(:record) { get_fixture('anthro_osteology_sparse1.xml') }
    let(:xpaths) {[
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateLower",
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateUpper",
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateDisplayDate",
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateEarliestScalarValue",
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateLatestScalarValue",
      { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[1]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
      { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[2]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateNote"
    ]}

    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end

    it 'osteoAgeEstimateVerbatim is empty' do
      xpath = "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateVerbatim"
      conv_text = get_text(doc, xpath)
      expect(conv_text).to be_empty, -> { "Xpath for doc was populated: #{xpath}" }
    end
    end #context without verbatim age column

    context 'in file with inconsistent verbatim age values, where row has...' do
      context 'both verbatim age values' do
        let(:attributes) { get_attributes_by_row('anthro', 'osteology_anthro_sparse2.csv', 2) }
        let(:doc) { get_doc(anthroosteology) }
        let(:record) { get_fixture('anthro_osteology.xml') }
        let(:xpaths) {[
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateVerbatim",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateLower",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateUpper",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateDisplayDate",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateEarliestScalarValue",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateLatestScalarValue",
          { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[1]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
          { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[2]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateNote"
        ]}

        it "Maps attributes correctly" do
          test_converter(doc, record, xpaths)
        end
      end #both verbatim age values

      context 'blank verbatim age cell' do
        let(:attributes) { get_attributes_by_row('anthro', 'osteology_anthro_sparse2.csv', 3) }
        let(:doc) { get_doc(anthroosteology) }
        let(:record) { get_fixture('anthro_osteology_sparse1.xml') }
        let(:xpaths) {[
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateLower",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateUpper",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateDisplayDate",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateEarliestScalarValue",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateLatestScalarValue",
          { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[1]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
          { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[2]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateNote"
        ]}

        it "Maps attributes correctly" do
          test_converter(doc, record, xpaths)
        end
        it 'osteoAgeEstimateVerbatim is empty' do
          xpath = "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateVerbatim"
          conv_text = get_text(doc, xpath)
          expect(conv_text).to be_empty, -> { "Xpath for doc was populated: #{xpath}" }
        end
      end #blank verbatim age cell

      context 'blank verbatim age cell ( ; )' do
        let(:attributes) { get_attributes_by_row('anthro', 'osteology_anthro_sparse2.csv', 4) }
        let(:doc) { get_doc(anthroosteology) }
        let(:record) { get_fixture('anthro_osteology_sparse1.xml') }
        let(:xpaths) {[
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateLower",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateUpper",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateDisplayDate",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateEarliestScalarValue",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateLatestScalarValue",
          { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[1]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
          { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[2]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateNote"
        ]}

        it "Maps attributes correctly" do
          test_converter(doc, record, xpaths)
        end
        it 'osteoAgeEstimateVerbatim is empty' do
          xpath = "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateVerbatim"
          conv_text = get_text(doc, xpath)
          expect(conv_text).to be_empty, -> { "Xpath for doc was populated: #{xpath}" }
        end
      end #blank verbatim age cell

      context 'only one verbatim age value' do
        let(:attributes) { get_attributes_by_row('anthro', 'osteology_anthro_sparse2.csv', 5) }
        let(:doc) { get_doc(anthroosteology) }
        let(:record) { get_fixture('anthro_osteology_sparse2_2.xml') }
        let(:xpaths) {[
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateVerbatim",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateLower",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateUpper",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[2]/osteoAgeEstimateDateGroup/dateDisplayDate",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[1]/osteoAgeEstimateDateGroup/dateDisplayDate",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateEarliestScalarValue",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateLatestScalarValue",
          { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[1]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
          { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[2]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateNote"
        ]}

        it "Maps attributes correctly" do
          test_converter(doc, record, xpaths)
        end
      end #context without verbatim age column

      context 'only one verbatim age value without proper multivalue delimiter in CSV' do
        let(:attributes) { get_attributes_by_row('anthro', 'osteology_anthro_sparse2.csv', 6) }
        let(:doc) { get_doc(anthroosteology) }
        let(:record) { get_fixture('anthro_osteology_sparse2_1.xml') }
        let(:xpaths) {[
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateVerbatim",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateLower",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateUpper",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateDisplayDate",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateEarliestScalarValue",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateLatestScalarValue",
          { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[1]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
          { xpath: "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[2]/osteoAgeEstimateAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateNote"
        ]}

        it "Maps attributes correctly" do
          test_converter(doc, record, xpaths)
        end
      end #context without verbatim age column

      context 'no verbatim, analyst, or date columns for ageEstimate' do
        let(:attributes) { get_attributes_by_row('anthro', 'osteology_anthro_sparse3.csv', 3) }
        let(:doc) { get_doc(anthroosteology) }
        let(:record) { get_fixture('anthro_osteology_sparse3_1.xml') }
        let(:xpaths) {[
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateLower",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateUpper",
          "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateNote"
        ]}

        it "Maps attributes correctly" do
          test_converter(doc, record, xpaths)
        end

        it 'osteoAgeEstimateVerbatim is empty' do
          xpath = "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateVerbatim"
          conv_text = get_text(doc, xpath)
          expect(conv_text).to be_empty, -> { "Xpath for doc was populated: #{xpath}" }
        end

        it 'structured date fields are empty' do
          xpath = "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateDisplayDate"
          conv_text = get_text(doc, xpath)
          expect(conv_text).to be_empty, -> { "Xpath for doc was populated: #{xpath}" }

          xpath = "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateEarliestScalarValue"
          conv_text = get_text(doc, xpath)
          expect(conv_text).to be_empty, -> { "Xpath for doc was populated: #{xpath}" }

          xpath = "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup/osteoAgeEstimateDateGroup/dateLatestScalarValue"
          conv_text = get_text(doc, xpath)
          expect(conv_text).to be_empty, -> { "Xpath for doc was populated: #{xpath}" }
        end

        it 'analyst fields are empty' do
          xpath = "/document/#{p}/osteoAgeEstimateGroupList/osteoAgeEstimateGroup[1]/osteoAgeEstimateAnalyst"
          conv_text = get_text(doc, xpath)
          expect(conv_text).to be_empty, -> { "Xpath for doc was populated: #{xpath}" }
        end
      end #no verbatim, analyst, or date columns for ageEstimate
    end #context in file with...
    
    context 'no values for groupLists' do
      let(:attributes) { get_attributes_by_row('anthro', 'osteology_anthro_all.csv', 16) }
      let(:doc) { get_doc(anthroosteology) }
      let(:record) { get_fixture('anthro_osteology_all_row16.xml') }

      it 'cranialDeformationPresent to be empty' do
        xpath = "/document/#{ext}/cranialDeformationPresent"
        conv_text = get_text(doc, xpath)
        expect(conv_text).to be_empty
      end

      it 'trepanationPresent to be empty' do
        xpath = "/document/#{ext}/trepanationPresent"
        conv_text = get_text(doc, xpath)
        expect(conv_text).to be_empty
      end

      it 'cranialDeformationCategories is empty' do
        xpath = "/document/#{ext}/cranialDeformationCategories"
        conv_text = get_text(doc, xpath)
        expect(conv_text).to be_empty, -> { "Xpath for doc was populated: #{xpath}" }
      end

      it 'trepanationGroupList is empty' do
        xpath = "/document/#{ext}/trepanationGroupList"
        conv_text = get_text(doc, xpath)
        expect(conv_text).to be_empty, -> { "Xpath for doc was populated: #{xpath}" }
      end
    end #no values for groupLists

    context 'required fields only' do
      let(:attributes) { get_attributes_by_row('anthro', 'osteology_anthro_all.csv', 17) }
      let(:doc) { get_doc(anthroosteology) }
      let(:record) { get_fixture('anthro_osteology_row17.xml') }
    let(:xpaths) {[
      "/document/#{p}/InventoryID",
      { xpath: "/document/#{p}/inventoryAnalyst", transform: ->(text) { CSURN.parse(text)[:label] } },
      "/document/#{p}/inventoryDate",
    ]}

      it 'required fields are populated' do
        test_converter(doc, record, xpaths)        
      end
    end #no values for groupLists
end
