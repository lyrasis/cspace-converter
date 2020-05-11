module Helpers
  # returns the first data row in the CSV
  # type = String. Cspace profile/subdirectory in data directory
  # file = String. Filename of CSV file in data directory
  def get_attributes(type, file)
    SmarterCSV.process(File.open(Rails.root.join('data', type, file), 'r:bom|utf-8'), {
      chunk_size: 1,
      convert_values_to_numeric: false,
    }.merge(Rails.application.config.csv_parser_options)) do |chunk|
      return JSON.parse(chunk[0].to_json)
    end
  end

  # returns specified row of data from the CSV
  # type = String. Cspace profile/subdirectory in data directory
  # file = String. Filename of CSV file in data directory
  # rownum = Integer. CSV row number, count starting from 1 and including header row.
  #  This lets you use the row number you see when you are looking at the data in Excel.
  def get_attributes_by_row(type, file, rownum)
    SmarterCSV.process(File.open(Rails.root.join('data', type, file), 'r:bom|utf-8'), {
      chunk_size: rownum - 1,
      convert_values_to_numeric: false,
    }.merge(Rails.application.config.csv_parser_options)) do |chunk|
      return JSON.parse(chunk.pop.to_json)
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

  def urn_values(doc, xpath)
    vals = []
    doc.xpath(xpath).each do |element|
      if element.text.start_with?('urn:')
        parsed = CSURN.parse(element.text)
        vals << [parsed[:type], parsed[:subtype], parsed[:label]].join(' - ')
      else
        vals << 'Not a URN'
      end
    end
    vals.sort.join('; ')
  end
  
  def test_base_basic_date(date)
    expect(date.computed).to eq 'true'
    expect(date.parsed_datetime.to_s).to eq '2011-11-02T00:00:00+00:00'
    expect(date.date_string).to eq basic_date
    expect(date.earliest_day).to eq 2
    expect(date.earliest_month).to eq 11
    expect(date.earliest_year).to eq 2011
    expect(date.earliest_scalar).to eq '2011-11-02T00:00:00.000Z'
  end

  def test_converter(doc, record, xpaths)
    xpaths.each do |xpath|
#      puts xpath
      doc_text = get_text(doc, xpath)
      record_text = get_text(record, xpath)
#      unless doc_text == record_text
#        puts "CONVERTER RESULT for #{xpath}: #{doc_text}"
#        puts "EXPECTED RESULT for #{xpath}: #{record_text}"
#      end
      expect(doc_text).not_to be_empty, -> { "Xpath for doc was empty: #{xpath}" }
      expect(record_text).not_to be_empty, -> { "Xpath for record was empty: #{xpath}" }
      expect(doc_text).to eq(record_text), -> { "Xpath match failure: #{xpath}\n#{doc_text}\n#{record_text}" }
    end
  end
end
