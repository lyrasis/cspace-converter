# frozen_string_literal: true

FactoryBot.define do
  factory :batch do
    key { SecureRandom.uuid }
    type { 'import' }
    add_attribute(:for) { 'Media' }
    name { 'batch1' }
  end

  factory :cache_object do
    refname { "urn:cspace:core.collectionspace.org:orgauthorities:name(organization):item:name(BarnesFoundation1542642516661)'Barnes Foundation'" }
    name { 'Barnes Foundation' }
    identifier { 'BarnesFoundation1542642516661' }
    rev { 0 }
    parent_refname { "urn:cspace:core.collectionspace.org:orgauthorities:name(organization)'Local Organizations'" }
    parent_rev { 0 }
  end

  factory :collection_space_object do
    batch { 'cataloging1' }
    category { 'Procedure' }
    converter { 'CollectionSpace::Converter::Core:CoreCollectionObject' }
    type { 'CollectionObject' }
    subtype { nil }
    identifier_field { 'id_number' }
    identifier { '1' }
    title { 'An object' }
  end

  factory :data_object do
    converter_profile { 'cataloging' }
    import_batch { 'cataloging1' }
    import_category { 'Procedures' }
    import_file { 'cataloging1.csv' }
    csv_data { { id: '1' } }
  end
end
