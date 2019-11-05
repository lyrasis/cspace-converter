RSpec.describe CollectionSpace::Converter::Core::CoreLoanOut do
  let(:attributes) { get_attributes('core', 'loansout_core_all.csv') }
  let(:coreloanout) { CoreLoanOut.new(attributes) }
  let(:doc) { Nokogiri::XML(coremedia.convert, nil, 'UTF-8') }
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
    { xpath: '/document/*/loanStatusGroupList/loanStatusGroup/loanStatus', transform: ->(text) { CSURN.parse(text)[:label] } },
    '/document/*/loanStatusGroupList/loanStatusGroup/loanStatusDate',
    '/document/*/loanStatusGroupList/loanStatusGroup/loanStatusNote',
  ]}

  it "Maps attributes correctly" do
    test_converter(doc, record, xpaths)
  end
end
