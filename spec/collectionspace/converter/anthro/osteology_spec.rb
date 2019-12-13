require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Anthro::AnthroOsteology do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'anthro.collectionspace.org'
  end

  let(:attributes) { get_attributes('anthro', 'osteology_anthro_all.csv') }
  let(:anthroosteology) { AnthroOsteology.new(attributes) }
  let(:doc) { get_doc(anthroosteology) }
  let(:record) { get_fixture('anthro_osteology.xml') }
  let(:p) { 'osteology_common' }
  let(:ext) { 'osteology_anthropology' }
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
end
