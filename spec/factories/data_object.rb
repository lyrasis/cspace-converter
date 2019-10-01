FactoryGirl.define do

  factory :data_object do
    converter_profile 'cataloging'
    import_batch 'cat1'
    import_category 'Procedures'
    import_file 'cat1.csv'
    object_data { {a: 'b'} }
  end

end
