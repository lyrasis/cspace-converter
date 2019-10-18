def prefab_authority_object
  build(
    :collection_space_object,
    category: 'Authority',
    type: 'Person',
    subtype: 'person',
    identifier: 'Mickey Mouse',
    title: 'Mickey Mouse',
  )
end

def prefab_data_object
  build(
    :data_object,
    converter_profile: 'cataloging',
    import_batch: 'cataloging1',
    import_category: 'Procedures',
    import_file: 'cataloging1.csv',
    object_data: { id: '123' },
  )
end

def prefab_procedure_object
  build(
    :collection_space_object,
    category: 'Procedure',
    type: 'Acquisition',
    identifier_field: 'acquisitionReferenceNumber',
    identifier: '123',
  )
end
