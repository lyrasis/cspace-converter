require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreConditionCheck do
  let(:attributes) { get_attributes('core', 'conditioncheck_core_all.csv') }
  let(:coreconditioncheck) { CoreConditionCheck.new(attributes) }
  let(:doc) { Nokogiri::XML(coreconditioncheck.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_condition_check.xml') }
  let(:xpaths) {[
    '/document/*/conditionCheckRefNumber',
    '/document/*/conditionCheckAssessmentDate',
    '/document/*/conditionCheckMethod',
    '/document/*/conditionCheckNote',
    '/document/*/conditionCheckReason',
    { xpath: '/document/*/conditionChecker', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/objectAuditCategory',
    '/document/*/completenessGroupList/completenessGroup/completenessDate',
    '/document/*/completenessGroupList/completenessGroup/completeness',
    '/document/*/completenessGroupList/completenessGroup/completenessNote',
    '/document/*/conditionCheckGroupList/conditionCheckGroup/conditionNote',
    '/document/*/conditionCheckGroupList/conditionCheckGroup/condition',
    '/document/*/conditionCheckGroupList/conditionCheckGroup/conditionDate',
    '/document/*/conservationTreatmentPriority',
    '/document/*/envConditionNoteGroupList/envConditionNoteGroup/envConditionNoteDate',
    '/document/*/envConditionNoteGroupList/envConditionNoteGroup/envConditionNote',
    '/document/*/nextConditionCheckDate',
    '/document/*/techAssessmentGroupList/techAssessmentGroup/techAssessment',
    '/document/*/techAssessmentGroupList/techAssessmentGroup/techAssessmentDate',
    '/document/*/hazardGroupList/hazardGroup/hazard',
    '/document/*/hazardGroupList/hazardGroup/hazardDate',
    '/document/*/hazardGroupList/hazardGroup/hazardNote',
    '/document/*/displayRecommendations',
    '/document/*/envRecommendations',
    '/document/*/handlingRecommendations',
    '/document/*/packingRecommendations',
    '/document/*/securityRecommendations',
    '/document/*/specialRequirements',
    '/document/*/storageRequirements',
    '/document/*/salvagePriorityCodeGroupList/salvagePriorityCodeGroup/salvagePriorityCode',
    '/document/*/salvagePriorityCodeGroupList/salvagePriorityCodeGroup/salvagePriorityCodeDate',
    '/document/*/legalRequirements',
    '/document/*/legalReqsHeldGroupList/legalReqsHeldGroup/legalReqsHeld',
    '/document/*/legalReqsHeldGroupList/legalReqsHeldGroup/legalReqsHeldBeginDate',
    '/document/*/legalReqsHeldGroupList/legalReqsHeldGroup/legalReqsHeldRenewDate',
    '/document/*/legalReqsHeldGroupList/legalReqsHeldGroup/legalReqsHeldEndDate',
    '/document/*/legalReqsHeldGroupList/legalReqsHeldGroup/legalReqsHeldNumber'
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end

