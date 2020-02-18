require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreIntake do
  let(:attributes) { get_attributes('core', 'intake_core_all.csv') }
  let(:coreintake) { CoreIntake.new(attributes) }
  let(:doc) { Nokogiri::XML(coreintake.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_intakes_row2.xml') }
  # xpaths in order of fields output in fixture file, to make it easier to check that they are all present/tested
  let(:xpaths) {[
    '/document/*/fieldCollectionDate',
    '/document/*/fieldCollectionNote',
    { xpath: '/document/*/conditionCheckersOrAssessors/conditionCheckerOrAssessor[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/conditionCheckersOrAssessors/conditionCheckerOrAssessor[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[3]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[4]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/valuer', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/normalLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/valuationReferenceNumber',
    { xpath: '/document/*/fieldCollectionMethods/fieldCollectionMethod[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionMethods/fieldCollectionMethod[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/insuranceNote',
    '/document/*/packingNote',
    '/document/*/returnDate',
    '/document/*/depositorsRequirements',
    '/document/*/insuranceReferenceNumber',
    { xpath: '/document/*/entryMethods/entryMethod[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/entryMethods/entryMethod[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/insurancePolicyNumber',
    { xpath: '/document/*/insurers/insurer[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/insurers/insurer[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/insurers/insurer[3]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/insurers/insurer[4]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentOwner', transform: ->(text) { CSURN.parse(text)[:label] } },    
    '/document/*/conditionCheckReferenceNumber',
    { xpath: '/document/*/conditionCheckReasons/conditionCheckReason[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/conditionCheckReasons/conditionCheckReason[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/entryReason',
    { xpath: '/document/*/conditionCheckMethods/conditionCheckMethod[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/conditionCheckMethods/conditionCheckMethod[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/fieldCollectionEventNames/fieldCollectionEventName',
    '/document/*/entryDate',
    '/document/*/fieldCollectionNumber',
    '/document/*/currentLocationGroupList/currentLocationGroup/currentLocationNote',
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup[1]/currentLocationFitness', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup[2]/currentLocationFitness', transform: ->(text) { CSURN.parse(text)[:label] } },
    # #3 is blank
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup[4]/currentLocationFitness', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup[1]/currentLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup[2]/currentLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup[3]/currentLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup[4]/currentLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/fieldCollectionPlace',
    '/document/*/conditionCheckNote',
    '/document/*/entryNote',
    '/document/*/insuranceRenewalDate',
    { xpath: '/document/*/approvalGroupList/approvalGroup[1]/approvalStatus', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[2]/approvalStatus', transform: ->(text) { CSURN.parse(text)[:label] } },       { xpath: '/document/*/approvalGroupList/approvalGroup[1]/approvalGroup', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[2]/approvalGroup', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/approvalGroupList/approvalGroup[1]/approvalNote',
    # approvalGroup[2] approvalNote is expected to be blank
    '/document/*/approvalGroupList/approvalGroup[1]/approvalDate',
    # approvalGroup[2] approvalDate is expected to be blank
    { xpath: '/document/*/approvalGroupList/approvalGroup[1]/approvalIndividual', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/approvalGroupList/approvalGroup[2]/approvalIndividual', transform: ->(text) { CSURN.parse(text)[:label] } },    
    '/document/*/conditionCheckDate',
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/entryNumber',
    { xpath: '/document/*/depositor', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/locationDate',
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'intake_core_all.csv', 22) }
    let(:doc) { Nokogiri::XML(coreintake.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_intakes_row22.xml') }
    let(:xpath_required) {[
      '/document/*/entryNumber'
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
