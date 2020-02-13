require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Core::CoreLoanIn do
  let(:attributes) { get_attributes('core', 'loanin_core_all.csv') }
  let(:coreloanin) { CoreLoanIn.new(attributes) }
  let(:doc) { Nokogiri::XML(coreloanin.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_loanin.xml') }
  let(:xpaths) {[
    '/document/*/loanInNumber',
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[1]/loanStatus', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[1]/loanStatus', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[2]/loanStatus', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[2]/loanStatus', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[1]/loanIndividual', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[1]/loanIndividual', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[2]/loanIndividual', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[2]/loanIndividual', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[1]/loanGroup', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[1]/loanGroup', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[2]/loanGroup', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup[2]/loanGroup', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/loanStatusGroupList/loanStatusGroup/loanStatusDate',
    '/document/*/loanStatusGroupList/loanStatusGroup/loanStatusNote',
    { xpath: '/document/*/lenderGroupList/lenderGroup[1]/lender', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/lenderGroupList/lenderGroup[1]/lender', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/lenderGroupList/lenderGroup[2]/lender', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/lenderGroupList/lenderGroup[2]/lender', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/lenderGroupList/lenderGroup[1]/lendersAuthorizer', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/lenderGroupList/lenderGroup[1]/lendersAuthorizer', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/lenderGroupList/lenderGroup[2]/lendersAuthorizer', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/lenderGroupList/lenderGroup[2]/lendersAuthorizer', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    '/document/*/lenderGroupList/lenderGroup/lendersAuthorizationDate',
    { xpath: '/document/*/lenderGroupList/lenderGroup[1]/lendersContact', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/lenderGroupList/lenderGroup[1]/lendersContact', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/lenderGroupList/lenderGroup[2]/lendersContact', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/lenderGroupList/lenderGroup[2]/lendersContact', transform: ->(text) { CSURN.parse(text)[:subtype] } },
    { xpath: '/document/*/borrowersContact', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/borrowersAuthorizer', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/borrowersAuthorizationDate',
    '/document/*/loanInConditions',
    '/document/*/loanInDate',
    '/document/*/loanReturnDate',
    '/document/*/loanRenewalApplicationDate',
    '/document/*/loanInNote',
    '/document/*/loanPurpose'
  ]}
  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'loanin_core_all.csv', 12) }
    let(:doc) { Nokogiri::XML(coreloanin.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_loanin_row12.xml') }
    let(:xpath_required) {[
      '/document/*/loanInNumber'
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end
end
