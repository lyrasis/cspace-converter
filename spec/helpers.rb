module Helpers
  def get_attributes(type, file)
    SmarterCSV.process(Rails.root.join('data', type, file), {
      chunk_size: 1,
      convert_values_to_numeric: false,
    }.merge(Rails.application.config.csv_parser_options)) do |chunk|
      return JSON.parse(chunk[0].to_json)
    end
  end

  def get_fixture(file)
    File.open(
      Rails.root.join('spec', 'fixtures', 'files', file)
    ) { |f| Nokogiri::XML(f) }
  end

  def get_text(doc, xpath)
    if xpath.respond_to? :key
      t = doc.xpath(xpath[:xpath]).text
      xpath[:transform].call(t)
    else
      doc.xpath(xpath).text
    end
  end

  def test_converter(doc, record, xpaths)
    xpaths.each do |xpath|
      doc_text = get_text(doc, xpath)
      record_text = get_text(record, xpath)
      expect(doc_text).not_to be_empty
      expect(record_text).not_to be_empty
      expect(doc_text).to eq(record_text)
    end
  end
end
