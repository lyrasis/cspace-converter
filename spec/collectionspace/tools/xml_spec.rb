require 'rails_helper'

RSpec.describe CSXML do
  def builder
    Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      xml.root { yield xml }
    end
  end

  def doc(xml)
    Nokogiri::XML(xml.to_xml)
  end
  let(:source_data_date) { '1971' }
  let(:structured_date) { CSDTP.parse(source_data_date) }

  it "can 'add' correctly" do
    x = builder do |xml|
      CSXML.add(xml, 'foo', 'bar')
    end
    expect(doc(x).xpath('/root/foo').text).to eq('bar')
  end

  it "can 'add group' correctly" do
    key = 'accessionDate'
    elements = {
      "dateDisplayDate" => '01-01-2000',
      'dateLatestDay' => '10?',
    }
    x = builder do |xml|
      CSXML.add_group(xml, key, elements)
    end
    expect(doc(x).xpath(
      '/root/accessionDateGroup/dateDisplayDate').text).to eq('01-01-2000')
    expect(doc(x).xpath(
      '/root/accessionDateGroup/dateLatestDay').text).to eq('10?')
  end

  it "can 'add group list' correctly" do
    key = 'objectProductionDate'
    elements = [
      {
        "scalarValuesComputed" => true,
        "dateEarliestSingleDay" => structured_date.earliest_day,
        "dateEarliestScalarValue" => structured_date.earliest_scalar,
        "dateLatestScalarValue" => structured_date.latest_scalar,
        "dateLatestDay" => structured_date.latest_day,
      },
      {
        "scalarValuesComputed" => false,
      }
    ]
    x = builder do |xml|
      CSXML.add_group_list(xml, key, elements)
    end

    expect(doc(x).xpath(
      '/root/objectProductionDateGroupList/objectProductionDateGroup[position()=1]/scalarValuesComputed').text).to eq('true')
    expect(doc(x).xpath(
      '/root/objectProductionDateGroupList/objectProductionDateGroup[position()=2]/scalarValuesComputed').text).to eq('false')

    expect(doc(x).xpath(
      '/root/objectProductionDateGroupList/objectProductionDateGroup[position()=1]/dateEarliestScalarValue').text).to eq("1971-01-01T00:00:00.000Z")
    expect(doc(x).xpath(
      '/root/objectProductionDateGroupList/objectProductionDateGroup[position()=1]/dateLatestScalarValue').text).to eq("1972-01-01T00:00:00.000Z")
  end

  it "can 'add group list' without sub key and with sub elements correctly" do
    key = 'publicartProductionDate'
    elements = [
      {
        "publicartProductionDateType" => "Commission",
      },
      {
        "publicartProductionDateType" => "Purchase",
      }
    ]
    sub_elements = [
      {
        "publicartProductionDate" => {
          "scalarValuesComputed" => true,
          "dateEarliestSingleDay" => structured_date.earliest_day,
          "dateEarliestScalarValue" => structured_date.earliest_scalar,
          "dateLatestScalarValue" => structured_date.latest_scalar,
          "dateLatestDay" => structured_date.latest_day,
        },
      },
      {
        "publicartProductionDate" => {
          "scalarValuesComputed" => false,
      },
      }
    ]
    x = builder do |xml|
      CSXML.add_group_list(xml, key, elements, false, sub_elements)
    end

    expect(doc(x).xpath(
      '/root/publicartProductionDateGroupList/publicartProductionDateGroup[position()=1]/publicartProductionDate/scalarValuesComputed').text).to eq('true')
    expect(doc(x).xpath(
      '/root/publicartProductionDateGroupList/publicartProductionDateGroup[position()=1]/publicartProductionDateType').text).to eq('Commission')

    expect(doc(x).xpath(
      '/root/publicartProductionDateGroupList/publicartProductionDateGroup[position()=2]/publicartProductionDate/scalarValuesComputed').text).to eq('false')
    expect(doc(x).xpath(
      '/root/publicartProductionDateGroupList/publicartProductionDateGroup[position()=2]/publicartProductionDateType').text).to eq('Purchase')
  end

  it "can 'add data' correctly" do
    data = {
      "label" => "publicartProductionDateGroupList",
      "elements" => [
        {
          "publicartProductionDateGroup" => [
            {
              "publicartProductionDate" => [
                {
                  "scalarValuesComputed" => true,
                },
              ],
              "publicartProductionDateType" => "Commission",
            },
            {
              "publicartProductionDate" => [
                {
                  "scalarValuesComputed" => false,
                }
              ],
              "publicartProductionDateType" => "Purchase",
            },
          ],
        },
      ]
    }
    x = builder do |xml|
      CSXML.add_data(xml, data)
    end

    expect(doc(x).xpath(
      '/root/publicartProductionDateGroupList/publicartProductionDateGroup[position()=1]/publicartProductionDate/scalarValuesComputed').text).to eq('true')

    expect(doc(x).xpath(
      '/root/publicartProductionDateGroupList/publicartProductionDateGroup[position()=2]/publicartProductionDate/scalarValuesComputed').text).to eq('false')
  end

  describe "Contact" do
    let(:contact) {{
      'email' => 'no-reply@collectionspace.org'
    }}
    it "can map correctly" do
      x = builder do |xml|
        Contact.map(xml, contact)
      end
      expect(doc(x).xpath('/root/emailGroupList/emailGroup/email').text).to eq contact['email']
    end
  end
end
