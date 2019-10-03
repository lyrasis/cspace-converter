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

def prefab_procedure_object
  build(
    :collection_space_object,
    category: 'Procedure',
    type: 'Acquisition',
    identifier_field: 'acquisitionReferenceNumber',
    identifier: '123',
  )
end
