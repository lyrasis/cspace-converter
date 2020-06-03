require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Anthro::AnthroNagpra do
  after(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'core.collectionspace.org'
  end

  before(:all) do
    ENV['CSPACE_CONVERTER_DOMAIN'] = 'anthro.collectionspace.org'
  end

  let(:anthronagpra) { AnthroNagpra.new(attributes) }
  let(:p) { 'claims_common' }
  let(:ext) { 'claims_nagpra' }
  let(:attributes) { get_attributes('anthro', 'anthro_nagpra_all.csv') }
  let(:doc) { get_doc(anthronagpra) }
  let(:record) { get_fixture('anthro_nagpra.xml') }
  let(:xpaths) {[
    "/document/#{p}/claimNumber",
    "/document/#{ext}/nagpraClaimName",
    { xpath: "/document/#{ext}/nagpraClaimTypes/nagpraClaimType[1]", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/#{ext}/nagpraClaimTypes/nagpraClaimType[2]", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/#{ext}/nagpraClaimAltNameGroupList/nagpraClaimAltNameGroup/nagpraClaimAltName",
    "/document/#{ext}/nagpraClaimAltNameGroupList/nagpraClaimAltNameGroup/nagpraClaimAltNameNote",
    "/document/#{p}/claimantGroupList/claimantGroup/claimantNote",
    { xpath: "/document/#{p}/claimantGroupList/claimantGroup[1]/claimFiledBy", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/claimantGroupList/claimantGroup[2]/claimFiledBy", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/claimantGroupList/claimantGroup[1]/claimFiledOnBehalfOf", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{p}/claimantGroupList/claimantGroup[2]/claimFiledOnBehalfOf", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{p}/claimReceivedGroupList/claimReceivedGroup/claimReceivedDate",
    "/document/#{p}/claimReceivedGroupList/claimReceivedGroup/claimReceivedNote",
    "/document/#{ext}/nagpraClaimNotes/nagpraClaimNote",
    { xpath: "/document/#{ext}/nagpraClaimSiteGroupList/nagpraClaimSiteGroup[1]/nagpraClaimSiteName", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{ext}/nagpraClaimSiteGroupList/nagpraClaimSiteGroup[2]/nagpraClaimSiteName", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{ext}/nagpraClaimSiteGroupList/nagpraClaimSiteGroup/nagpraClaimSiteNote",
    "/document/#{ext}/nagpraClaimGroupGroupList/nagpraClaimGroupGroup/nagpraClaimGroupNote",
    { xpath: "/document/#{ext}/nagpraClaimGroupGroupList/nagpraClaimGroupGroup[1]/nagpraClaimGroupName", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/#{ext}/nagpraClaimGroupGroupList/nagpraClaimGroupGroup[2]/nagpraClaimGroupName", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/#{ext}/nagpraClaimPeriodGroupList/nagpraClaimPeriodGroup/nagpraClaimPeriodNote",
    "/document/#{ext}/nagpraClaimPeriodGroupList/nagpraClaimPeriodGroup/nagpraClaimPeriodDateGroup/dateDisplayDate",
    "/document/#{ext}/nagpraClaimInitialResponseGroupList/nagpraClaimInitialResponseGroup/nagpraClaimInitialResponseDate",
    "/document/#{ext}/nagpraClaimInitialResponseGroupList/nagpraClaimInitialResponseGroup/nagpraClaimInitialResponseNote",
    "/document/#{ext}/nagpraClaimSentToLocalGroupList/nagpraClaimSentToLocalGroup/nagpraClaimSentToLocalDate",  
    "/document/#{ext}/nagpraClaimSentToLocalGroupList/nagpraClaimSentToLocalGroup/nagpraClaimSentToLocalNote",
    "/document/#{ext}/nagpraClaimLocalRecGroupList/nagpraClaimLocalRecGroup/nagpraClaimLocalRecDate",
    "/document/#{ext}/nagpraClaimLocalRecGroupList/nagpraClaimLocalRecGroup/nagpraClaimLocalRecNote",
    "/document/#{ext}/nagpraClaimSentToNatlGroupList/nagpraClaimSentToNatlGroup/nagpraClaimSentToNatlNote",
    "/document/#{ext}/nagpraClaimSentToNatlGroupList/nagpraClaimSentToNatlGroup/nagpraClaimSentToNatlDate",
    "/document/#{ext}/nagpraClaimNatlRespGroupList/nagpraClaimNatlRespGroup/nagpraClaimNatlRespNote",
    "/document/#{ext}/nagpraClaimNatlRespGroupList/nagpraClaimNatlRespGroup/nagpraClaimNatlRespDate",
    "/document/#{ext}/nagpraClaimNatlApprovalGroupList/nagpraClaimNatlApprovalGroup/nagpraClaimNatlApprovalDate",
    "/document/#{ext}/nagpraClaimNatlApprovalGroupList/nagpraClaimNatlApprovalGroup/nagpraClaimNatlApprovalNote",
    "/document/#{ext}/nagpraClaimNoticeGroupList/nagpraClaimNoticeGroup/nagpraClaimNoticeNote",
    "/document/#{ext}/nagpraClaimNoticeGroupList/nagpraClaimNoticeGroup/nagpraClaimNoticeDateType",
    "/document/#{ext}/nagpraClaimNoticeGroupList/nagpraClaimNoticeGroup/nagpraClaimNoticeDate",
    "/document/#{ext}/nagpraClaimTransferGroupList/nagpraClaimTransferGroup/nagpraClaimTransferDate",
    "/document/#{ext}/nagpraClaimTransferGroupList/nagpraClaimTransferGroup/nagpraClaimTransferNote",
    "/document/#{ext}/dispositionPossibilitiesDiscussedNote",
    "/document/#{ext}/dispositionPossibilitiesDiscussed",
    "/document/#{ext}/surroundingTribesContactedNote",
    "/document/#{ext}/surroundingTribesContacted",
    "/document/#{ext}/workingTeamNotifiedNote",
    "/document/#{ext}/workingTeamNotified",
    "/document/#{ext}/siteFileResearchCompletedNote",
    "/document/#{ext}/siteFileResearchCompleted",
    "/document/#{ext}/accessionFileResearchCompletedNote",
    "/document/#{ext}/accessionFileResearchCompleted",
    "/document/#{ext}/objectsLocatedAndCountedNote",
    "/document/#{ext}/objectsLocatedAndCounted",
    "/document/#{ext}/objectsConsolidatedNote",
    "/document/#{ext}/objectsConsolidated",
    "/document/#{ext}/objectsPhotographedNote",
    "/document/#{ext}/objectsPhotographed",
    "/document/#{ext}/registrationDocumentsDraftedNote",
    "/document/#{ext}/registrationDocumentsDrafted",
    "/document/#{ext}/tribeContactedForPackingPreferencesNote",
    "/document/#{ext}/tribeContactedForPackingPreferences",
    "/document/#{ext}/dateArrangedForTransferNote",
    "/document/#{ext}/dateArrangedForTransfer",
    "/document/#{ext}/objectsMarkedAsDeaccessionedNote",
    "/document/#{ext}/objectsMarkedAsDeaccessioned",
    "/document/#{ext}/documentsArchivedNote",
    "/document/#{ext}/documentsArchived"
  ]}
    
  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end

  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('anthro', 'anthro_nagpra_all.csv', 12) }
    let(:doc) { get_doc(anthronagpra) }
    let(:record) { get_fixture('anthro_nagpra_row12.xml') }
    let(:p) { 'claims_common' }
    let(:xpath_required) {[
      "/document/#{p}/claimNumber"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
