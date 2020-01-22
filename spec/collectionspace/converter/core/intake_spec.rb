require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreIntake do
  let(:attributes) { get_attributes('core', 'intake_core_all.csv') }
  let(:coreintake) { CoreIntake.new(attributes) }
  let(:doc) { Nokogiri::XML(coreintake.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_intakes_row2.xml') }
  let(:xpaths) {[
    { xpath: '/document/*/currentOwner', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/depositor', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/depositorsRequirements',
    '/document/*/entryDate',
    { xpath: '/document/*/entryMethods/entryMethod[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/entryMethods/entryMethod[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/entryNote',
    '/document/*/entryNumber',
    '/document/*/entryReason',
    '/document/*/packingNote',
    '/document/*/returnDate',
    '/document/*/fieldCollectionDate',
    { xpath: '/document/*/fieldCollectionMethods/fieldCollectionMethod[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionMethods/fieldCollectionMethod[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/fieldCollectionNote',
    '/document/*/fieldCollectionNumber',
    '/document/*/fieldCollectionPlace',
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[3]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector[4]', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/fieldCollectionEventNames/fieldCollectionEventName',
    '/document/*/valuationReferenceNumber',
    { xpath: '/document/*/valuer', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/insuranceNote',
    '/document/*/insurancePolicyNumber',
    '/document/*/insuranceReferenceNumber',
    '/document/*/insuranceRenewalDate',
    { xpath: '/document/*/insurers/insurer[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/insurers/insurer[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/insurers/insurer[3]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/insurers/insurer[4]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup[1]/currentLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup[2]/currentLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup[3]/currentLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup[4]/currentLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup/currentLocationFitness', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/currentLocationGroupList/currentLocationGroup/currentLocationNote',
    '/document/*/locationDate',
    { xpath: '/document/*/normalLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/conditionCheckDate',
# Not sure why the CSURN.parse to label is not converting these values properly
    { xpath: '/document/*/conditionCheckMethods/conditionCheckMethod[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/conditionCheckMethods/conditionCheckMethod[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/conditionCheckNote',
    # Not sure why the CSURN.parse to label is not converting these values properly
    { xpath: '/document/*/conditionCheckReasons/conditionCheckReason[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/conditionCheckReasons/conditionCheckReason[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/conditionCheckReferenceNumber',
    { xpath: '/document/*/conditionCheckersOrAssessors/conditionCheckerOrAssessor[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/conditionCheckersOrAssessors/conditionCheckerOrAssessor[2]', transform: ->(text) { CSURN.parse(text)[:label] } }    
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end

