FactoryBot.define do

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

end
