require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Materials::MaterialsMaterial do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'materials.collectionspace.org'
  end

  let(:attributes) { get_attributes('materials', 'materials_authority.csv') }
  let(:materialsmaterial) { MaterialsMaterial.new(attributes) }
  let(:doc) { get_doc(materialsmaterial) }
  let(:record) { get_fixture('materials_authority.xml') }
  let(:xpaths) {[
    "/document/*/materialTermGroupList/materialTermGroup/termDisplayName",
    "/document/*/materialTermGroupList/materialTermGroup/termName",
    "/document/*/materialTermGroupList/materialTermGroup/termQualifier",
    "/document/*/materialTermGroupList/materialTermGroup/termStatus",
    "/document/*/materialTermGroupList/materialTermGroup/termType",
    { xpath: '/document/*/materialTermGroupList/materialTermGroup/termFlag', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/materialTermGroupList/materialTermGroup/historicalStatus",
    { xpath: '/document/*/materialTermGroupList/materialTermGroup/termLanguage', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/materialTermGroupList/materialTermGroup/termPrefForLang",
    { xpath: '/document/*/materialTermGroupList/materialTermGroup/termSource', transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/materialTermGroupList/materialTermGroup/termSourceDetail",
    "/document/*/materialTermGroupList/materialTermGroup/termSourceID",
    "/document/*/materialTermGroupList/materialTermGroup/termSourceNote",
    { xpath: '/document/*/publishToList/publishTo', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/materialCompositionGroupList/materialCompositionGroup[1]/materialCompositionFamilyName', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialCompositionGroupList/materialCompositionGroup[1]/materialCompositionClassName', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialCompositionGroupList/materialCompositionGroup[1]/materialCompositionGenericName', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialCompositionGroupList/materialCompositionGroup[2]/materialCompositionFamilyName', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialCompositionGroupList/materialCompositionGroup[2]/materialCompositionClassName', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialCompositionGroupList/materialCompositionGroup[2]/materialCompositionGenericName', transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/description",
    { xpath: '/document/*/typicalUses/typicalUse', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/discontinued",
    { xpath: '/document/*/discontinuedBy', transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/discontinuedDate/dateDisplayDate",
    "/document/*/productionDate/dateDisplayDate",
    "/document/*/productionNote",
    { xpath: '/document/*/materialProductionOrganizationGroupList/materialProductionOrganizationGroup[1]/materialProductionOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialProductionOrganizationGroupList/materialProductionOrganizationGroup[2]/materialProductionOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialProductionOrganizationGroupList/materialProductionOrganizationGroup/materialProductionOrganizationRole', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/materialProductionPersonGroupList/materialProductionPersonGroup[1]/materialProductionPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialProductionPersonGroupList/materialProductionPersonGroup[2]/materialProductionPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialProductionPersonGroupList/materialProductionPersonGroup/materialProductionPersonRole', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/materialProductionPlaceGroupList/materialProductionPlaceGroup[1]/materialProductionPlace', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialProductionPlaceGroupList/materialProductionPlaceGroup[2]/materialProductionPlace', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialProductionPlaceGroupList/materialProductionPlaceGroup/materialProductionPlaceRole', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/featuredApplicationGroupList/featuredApplicationGroup[1]/featuredApplication', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/featuredApplicationGroupList/featuredApplicationGroup[2]/featuredApplication', transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/featuredApplicationGroupList/featuredApplicationGroup/featuredApplicationNote",
    { xpath: '/document/*/materialCitationGroupList/materialCitationGroup[1]/materialCitationSource', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialCitationGroupList/materialCitationGroup[2]/materialCitationSource', transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/materialCitationGroupList/materialCitationGroup/materialCitationSourceDetail",
    "/document/*/externalUrlGroupList/externalUrlGroup/externalUrl",
    "/document/*/externalUrlGroupList/externalUrlGroup/externalUrlNote",
    { xpath: '/document/*/additionalResourceGroupList/additionalResourceGroup/additionalResource', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/additionalResourceGroupList/additionalResourceGroup/additionalResourceNote",
    { xpath: '/document/*/materialTermAttributionContributingGroupList/materialTermAttributionContributingGroup[1]/materialTermAttributionContributingOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialTermAttributionContributingGroupList/materialTermAttributionContributingGroup[2]/materialTermAttributionContributingOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialTermAttributionContributingGroupList/materialTermAttributionContributingGroup[1]/materialTermAttributionContributingPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialTermAttributionContributingGroupList/materialTermAttributionContributingGroup[2]/materialTermAttributionContributingPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/materialTermAttributionContributingGroupList/materialTermAttributionContributingGroup/materialTermAttributionContributingDate",
    { xpath: '/document/*/materialTermAttributionEditingGroupList/materialTermAttributionEditingGroup[1]/materialTermAttributionEditingOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialTermAttributionEditingGroupList/materialTermAttributionEditingGroup[2]/materialTermAttributionEditingOrganization', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialTermAttributionEditingGroupList/materialTermAttributionEditingGroup[1]/materialTermAttributionEditingPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/materialTermAttributionEditingGroupList/materialTermAttributionEditingGroup[2]/materialTermAttributionEditingPerson', transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/materialTermAttributionEditingGroupList/materialTermAttributionEditingGroup/materialTermAttributionEditingNote",
    "/document/*/materialTermAttributionEditingGroupList/materialTermAttributionEditingGroup/materialTermAttributionEditingDate",
    { xpath: '/document/*/commonForm', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/formTypeGroupList/formTypeGroup/formType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/typicalSizeGroupList/typicalSizeGroup/typicalSize",
    "/document/*/typicalSizeGroupList/typicalSizeGroup/typicalSizeDimensionGroupList/typicalSizeDimensionGroup/dimension",
    "/document/*/typicalSizeGroupList/typicalSizeGroup/typicalSizeDimensionGroupList/typicalSizeDimensionGroup/value",
    "/document/*/typicalSizeGroupList/typicalSizeGroup/typicalSizeDimensionGroupList/typicalSizeDimensionGroup/measurementUnit",
    "/document/*/formNote",
    { xpath: '/document/*/acousticalPropertyGroupList/acousticalPropertyGroup[1]/acousticalPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/acousticalPropertyGroupList/acousticalPropertyGroup[2]/acousticalPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/acousticalPropertyGroupList/acousticalPropertyGroup/acousticalPropertyNote",
    { xpath: '/document/*/durabilityPropertyGroupList/durabilityPropertyGroup[1]/durabilityPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/durabilityPropertyGroupList/durabilityPropertyGroup[2]/durabilityPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/durabilityPropertyGroupList/durabilityPropertyGroup/durabilityPropertyNote",
    { xpath: '/document/*/electricalPropertyGroupList/electricalPropertyGroup[1]/electricalPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/electricalPropertyGroupList/electricalPropertyGroup[2]/electricalPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/electricalPropertyGroupList/electricalPropertyGroup/electricalPropertyNote",
    { xpath: '/document/*/hygrothermalPropertyGroupList/hygrothermalPropertyGroup/hygrothermalPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/hygrothermalPropertyGroupList/hygrothermalPropertyGroup/hygrothermalPropertyNote",
    { xpath: '/document/*/mechanicalPropertyGroupList/mechanicalPropertyGroup[1]/mechanicalPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/mechanicalPropertyGroupList/mechanicalPropertyGroup[2]/mechanicalPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/mechanicalPropertyGroupList/mechanicalPropertyGroup/mechanicalPropertyNote",
    { xpath: '/document/*/opticalPropertyGroupList/opticalPropertyGroup/opticalPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/opticalPropertyGroupList/opticalPropertyGroup/opticalPropertyNote",
    { xpath: '/document/*/sensorialPropertyGroupList/sensorialPropertyGroup[1]/sensorialPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/sensorialPropertyGroupList/sensorialPropertyGroup[2]/sensorialPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/sensorialPropertyGroupList/sensorialPropertyGroup/sensorialPropertyNote",
    { xpath: '/document/*/smartMaterialPropertyGroupList/smartMaterialPropertyGroup/smartMaterialPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/smartMaterialPropertyGroupList/smartMaterialPropertyGroup/smartMaterialPropertyNote",
    { xpath: '/document/*/additionalPropertyGroupList/additionalPropertyGroup/additionalPropertyType', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/additionalPropertyGroupList/additionalPropertyGroup/additionalPropertyNote",
    "/document/*/propertyNote",
    "/document/*/recycledContentGroupList/recycledContentGroup/recycledContent",
    "/document/*/recycledContentGroupList/recycledContentGroup/recycledContentHigh",
    "/document/*/recycledContentGroupList/recycledContentGroup/recycledContentQualifier",
    { xpath: '/document/*/lifecycleComponentGroupList/lifecycleComponentGroup/lifecycleComponent', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/lifecycleComponentGroupList/lifecycleComponentGroup/lifecycleComponentNote",
    "/document/*/embodiedEnergyGroupList/embodiedEnergyGroup/embodiedEnergyValue",
    "/document/*/embodiedEnergyGroupList/embodiedEnergyGroup/embodiedEnergyValueHigh",
    { xpath: '/document/*/embodiedEnergyGroupList/embodiedEnergyGroup[1]/embodiedEnergyUnit', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/embodiedEnergyGroupList/embodiedEnergyGroup[2]/embodiedEnergyUnit', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/embodiedEnergyGroupList/embodiedEnergyGroup/embodiedEnergyNote",
    { xpath: '/document/*/certificationCreditGroupList/certificationCreditGroup/certificationProgram', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/certificationCreditGroupList/certificationCreditGroup/certificationCreditNote",
    "/document/*/ecologyNote",
    { xpath: '/document/*/castingProcesses/castingProcess', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/deformingProcesses/deformingProcess', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/joiningProcesses/joiningProcess', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/machiningProcesses/machiningProcess[1]', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/machiningProcesses/machiningProcess[2]', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/moldingProcesses/moldingProcess[1]', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/moldingProcesses/moldingProcess[2]', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/rapidPrototypingProcesses/rapidPrototypingProcess[1]', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/rapidPrototypingProcesses/rapidPrototypingProcess[2]', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/surfacingProcesses/surfacingProcess[1]', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/surfacingProcesses/surfacingProcess[2]', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/additionalProcessGroupList/additionalProcessGroup/additionalProcess', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/additionalProcessGroupList/additionalProcessGroup/additionalProcessNote",
    "/document/*/processNote",
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('materials', 'materials_authority.csv', 3) }
    let(:materialsmaterial) { MaterialsMaterial.new(attributes) }
    let(:doc) { Nokogiri::XML(materialsmaterial.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('materials_authority_row3.xml') }     
    let(:xpath_required) {[
      "/document/*/materialTermGroupList/materialTermGroup/termDisplayName"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end

end
