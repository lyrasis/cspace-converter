require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreConservation do
  let(:attributes) { get_attributes('core', 'conservation_core_all.csv') }
  let(:coreconservation) { CoreConservation.new(attributes) }
  let(:doc) { Nokogiri::XML(coreconservation.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_conservation.xml') }
  let(:xpaths) {[
    '/document/*/conservationNumber',
    { xpath: '/document/*/conservationStatusGroupList/conservationStatusGroup[1]/status', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/conservationStatusGroupList/conservationStatusGroup[2]/status', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    '/document/*/conservationStatusGroupList/conservationStatusGroup/statusDate',
    { xpath: '/document/*/treatmentPurpose', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/conservators/conservator[1]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/conservators/conservator[2]', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/otherPartyGroupList/otherPartyGroup[1]/otherParty', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/otherPartyGroupList/otherPartyGroup[2]/otherParty', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/otherPartyGroupList/otherPartyGroup/otherPartyNote',
    { xpath: '/document/*/otherPartyGroupList/otherPartyGroup/otherPartyRole', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/examinationGroupList/examinationGroup[1]/examinationStaff', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/examinationGroupList/examinationGroup[2]/examinationStaff', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/examinationGroupList/examinationGroup/examinationDate',
    { xpath: '/document/*/examinationGroupList/examinationGroup[1]/examinationPhase', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: '/document/*/examinationGroupList/examinationGroup[2]/examinationPhase', transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    '/document/*/examinationGroupList/examinationGroup/examinationNote',
    '/document/*/fabricationNote',
    '/document/*/proposedTreatment',
    { xpath: '/document/*/approvedBy', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/approvedDate',
    '/document/*/treatmentStartDate',
    '/document/*/treatmentEndDate',
    '/document/*/treatmentSummary',
    '/document/*/proposedAnalysis',
    { xpath: '/document/*/researcher', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/proposedAnalysisDate',
    { xpath: '/document/*/destAnalysisGroupList/destAnalysisGroup[1]/sampleBy', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/destAnalysisGroupList/destAnalysisGroup[2]/sampleBy', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/destAnalysisGroupList/destAnalysisGroup/destAnalysisApprovalNote',
    '/document/*/destAnalysisGroupList/destAnalysisGroup/sampleDescription',
    '/document/*/destAnalysisGroupList/destAnalysisGroup/destAnalysisApprovedDate',
    '/document/*/destAnalysisGroupList/destAnalysisGroup/sampleDate',
    '/document/*/destAnalysisGroupList/destAnalysisGroup[1]/sampleReturned',
    '/document/*/destAnalysisGroupList/destAnalysisGroup[2]/sampleReturned',
    '/document/*/destAnalysisGroupList/destAnalysisGroup/sampleReturnedLocation',
    '/document/*/analysisMethod',
    '/document/*/analysisResults',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end

