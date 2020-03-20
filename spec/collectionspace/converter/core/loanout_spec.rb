require 'rails_helper'


RSpec.describe CollectionSpace::Converter::Core::CoreLoanOut do
  let(:attributes) { get_attributes('core', 'loansout_core_all.csv') }
  let(:coreloanout) { CoreLoanOut.new(attributes) }
  let(:doc) { Nokogiri::XML(coreloanout.convert, nil, 'UTF-8') }
  let(:record) { get_fixture('core_loanout.xml') }
  let(:xpaths) {[
    '/document/*/loanOutNumber',
    { xpath: '/document/*/borrower', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/borrowersAuthorizer', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/borrowersAuthorizationDate',
    { xpath: '/document/*/borrowersContact', transform: ->(text) { CSURN.parse(text)[:label] } },
    { xpath: '/document/*/lendersAuthorizer', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/lendersAuthorizationDate',
    { xpath: '/document/*/lendersContact', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/loanOutDate',
    '/document/*/loanReturnDate',
    '/document/*/loanRenewalApplicationDate',
    '/document/*/specialConditionsOfLoan',
    '/document/*/loanOutNote',
    '/document/*/loanPurpose',
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
    '/document/*/loanStatusGroupList/loanStatusGroup/loanStatusNote'
  ]}
  context 'For maximally populuated record' do
    it "Maps attributes correctly" do
      test_converter(doc, record, xpaths)
    end
  end
  context 'For minimally populated record' do
    let(:attributes) { get_attributes_by_row('core', 'loansout_core_all.csv', 32) }    
    let(:doc) { Nokogiri::XML(coreloanout.convert, nil, 'UTF-8') }
    let(:record) { get_fixture('core_loanout_row32.xml') }
    let(:xpath_required) {[
      '/document/*/loanOutNumber'
    ]}

    it 'Maps required field(s) correctly without falling over' do
      test_converter(doc, record, xpath_required)
    end
  end 
end
