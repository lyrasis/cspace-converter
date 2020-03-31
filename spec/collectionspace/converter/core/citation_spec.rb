require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreCitation do
  let(:attributes) { get_attributes('core', 'authcitation_core_all.csv') }
  let(:corecitation) { CoreCitation.new(Lookup.profile_defaults('citation').merge(attributes)) }
  let(:doc) { get_doc(corecitation) }
  let(:record) { get_fixture('core_citation.xml') }
  let(:xpaths) {[
    "/document/*/citationTermGroupList/citationTermGroup/termDisplayName",
    "/document/*/citationTermGroupList/citationTermGroup/termTitle",
    { xpath: "/document/*/citationTermGroupList/citationTermGroup/termLanguage", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/citationTermGroupList/citationTermGroup/termPrefForLang",
    { xpath: "/document/*/citationTermGroupList/citationTermGroup/termType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/citationTermGroupList/citationTermGroup/termSource", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/citationTermGroupList/citationTermGroup/termSourceID",
    "/document/*/citationTermGroupList/citationTermGroup/termSourceDetail",
    "/document/*/citationTermGroupList/citationTermGroup/termSourceNote",
    "/document/*/citationTermGroupList/citationTermGroup/termVolume",
    "/document/*/citationTermGroupList/citationTermGroup/termFullCitation",
    "/document/*/citationTermGroupList/citationTermGroup/termSubTitle",
    "/document/*/citationTermGroupList/citationTermGroup/termSectionTitle",
    "/document/*/citationTermGroupList/citationTermGroup/termIssue",
    "/document/*/citationTermGroupList/citationTermGroup/termStatus",
    { xpath: "/document/*/citationTermGroupList/citationTermGroup/termFlag", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/citationPublicationInfoGroupList/citationPublicationInfoGroup[1]/publicationPlace", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/citationPublicationInfoGroupList/citationPublicationInfoGroup[2]/publicationPlace", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/citationPublicationInfoGroupList/citationPublicationInfoGroup[1]/publisher", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/citationPublicationInfoGroupList/citationPublicationInfoGroup[2]/publisher", transform: ->(text) { CSURN.parse(text)[:label] } },
    "/document/*/citationPublicationInfoGroupList/citationPublicationInfoGroup/pages",
    "/document/*/citationPublicationInfoGroupList/citationPublicationInfoGroup/edition",
    { xpath: "/document/*/citationPublicationInfoGroupList/citationPublicationInfoGroup[1]/publicationDate/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/*/citationPublicationInfoGroupList/citationPublicationInfoGroup[2]/publicationDate/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/*/citationAgentInfoGroupList/citationAgentInfoGroup[1]/agent", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/citationAgentInfoGroupList/citationAgentInfoGroup[2]/agent", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/citationAgentInfoGroupList/citationAgentInfoGroup[1]/role", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/citationAgentInfoGroupList/citationAgentInfoGroup[2]/role", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    "/document/*/citationAgentInfoGroupList/citationAgentInfoGroup/note",
    "/document/*/citationNote",
    "/document/*/citationResourceIdentGroupList/citationResourceIdentGroup/resourceIdent",
    { xpath: "/document/*/citationResourceIdentGroupList/citationResourceIdentGroup[1]/captureDate/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/*/citationResourceIdentGroupList/citationResourceIdentGroup[2]/captureDate/dateDisplayDate", transform: ->(text) { text.split('-')[0] } },
    { xpath: "/document/*/citationResourceIdentGroupList/citationResourceIdentGroup[1]/type", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/citationResourceIdentGroupList/citationResourceIdentGroup[2]/type", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/citationRelatedTermsGroupList/citationRelatedTermsGroup[1]/relatedTerm", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/citationRelatedTermsGroupList/citationRelatedTermsGroup[2]/relatedTerm", transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: "/document/*/citationRelatedTermsGroupList/citationRelatedTermsGroup[1]/relationType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
    { xpath: "/document/*/citationRelatedTermsGroupList/citationRelatedTermsGroup[2]/relationType", transform: ->(text) { CSURN.parse(text)[:label].downcase } },
  ]}

  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'authcitation_core_all.csv', 11) }
    let(:doc) { get_doc(corecitation) }
    let(:record) { get_fixture('core_citation_row11.xml') }
    let(:xpath_required) {[
      "/document/*/citationTermGroupList/citationTermGroup/termDisplayName"
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
