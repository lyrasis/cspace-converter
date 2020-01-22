require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreIntake do
  let(:attributes) { get_attributes('core', 'intake_core_all.csv') }
  let(:coreintake) { CoreIntake.new(attributes) }
  let(:doc) { Nokogiri::XML(coreintake.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_intakes.xml') }
  let(:xpaths) {[
    { xpath: '/document/*/currentOwner', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/depositor', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/depositorsRequirements',
    '/document/*/entryDate',
    { xpath: '/document/*/entryMethods/entryMethod', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/entryNote',
    '/document/*/entryNumber',
    '/document/*/entryReason',
    '/document/*/packingNote',
    '/document/*/returnDate',
    '/document/*/fieldCollectionDate',
    { xpath: '/document/*/fieldCollectionMethods/fieldCollectionMethod', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/fieldCollectionNote',
    '/document/*/fieldCollectionNumber',
    '/document/*/fieldCollectionPlace',
    { xpath: '/document/*/fieldCollectionSources/fieldCollectionSource', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/fieldCollectors/fieldCollector', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/fieldCollectionEventNames/fieldCollectionEventName',
    '/document/*/valuationReferenceNumber',
    { xpath: '/document/*/valuer', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/insuranceNote',
    '/document/*/insurancePolicyNumber',
    '/document/*/insuranceReferenceNumber',
    '/document/*/insuranceRenewalDate',
    { xpath: '/document/*/insurers/insurer', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup/currentLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/currentLocationGroupList/currentLocationGroup/currentLocationFitness', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/currentLocationGroupList/currentLocationGroup/currentLocationNote',
    '/document/*/locationDate',
    { xpath: '/document/*/normalLocation', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/conditionCheckDate',
    { xpath: '/document/*/conditionCheckMethods/conditionCheckMethod', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/conditionCheckNote',
    { xpath: '/document/*/conditionCheckReasons/conditionCheckReason', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/conditionCheckReferenceNumber',
    { xpath: '/document/*/conditionCheckersOrAssessors/conditionCheckersOrAssessor', transform: ->(text) { CSURN.parse(text)[:label] } }
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end

