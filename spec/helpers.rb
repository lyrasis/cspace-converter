module Helpers
  def get_attributes(type, file)
    SmarterCSV.process(Rails.root.join('data', type, file), {
      chunk_size: 1,
      convert_values_to_numeric: false,
    }.merge(Rails.application.config.csv_parser_options)) do |chunk|
      return JSON.parse(chunk[0].to_json)
    end
  end

  def get_doc(converter)
    Nokogiri::XML(converter.convert, nil, 'UTF-8').remove_namespaces!
  end

  def get_fixture(file)
    File.open(
      Rails.root.join('spec', 'fixtures', 'files', file)
    ) { |f| Nokogiri::XML(f).remove_namespaces! }
  end

  def get_text(doc, xpath)
    if xpath.respond_to? :key
      t = doc.xpath(xpath[:xpath]).text
      xpath[:transform].call(t)
    else
      doc.xpath(xpath).text
    end
  end

  def test_base_basic_date(date)
    expect(date.parsed_datetime.to_s).to eq '2011-11-02T00:00:00+00:00'
    expect(date.date_string).to eq basic_date
    expect(date.earliest_day).to eq 2
    expect(date.earliest_month).to eq 11
    expect(date.earliest_year).to eq 2011
    expect(date.earliest_scalar).to eq '2011-11-02T00:00:00.000Z'
  end

  def test_converter(doc, record, xpaths)
    xpaths.each do |xpath|
      doc_text = get_text(doc, xpath)
      record_text = get_text(record, xpath)
      expect(doc_text).not_to be_empty, -> { "Xpath for doc was empty: #{xpath}" }
      expect(record_text).not_to be_empty, -> { "Xpath for record was empty: #{xpath}" }
      expect(doc_text).to eq(record_text), -> { "Xpath match failure: #{xpath}\n#{doc_text}\n#{record_text}" }
    end
  end
end
