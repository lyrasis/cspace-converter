class DataObject
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :collection_space_objects, autosave: true, dependent: :destroy
  validates_presence_of :converter_module
  validates_presence_of :converter_profile
  validates_presence_of :csv_data
  validates_presence_of :import_category
  validate :module_and_profile_exist

  before_validation :set_module

  field :converter_module,  type: String # ex: Core
  field :converter_profile, type: String # ex: cataloging
  field :csv_data,          type: Hash
  field :import_batch,      type: String # ex: cat1
  field :import_file,       type: String # ex: cat1.csv
  field :import_message,    type: String, default: 'ok'
  field :import_status,     type: Integer, default: 1
  field :import_category,   type: String # ex: Procedures

  def add_cspace_object(cspace_object_data, content_data)
    cspace_object = CollectionSpaceObject.new(cspace_object_data)
    cspace_object.generate_content!(content_data)
    collection_space_objects << cspace_object if cspace_object.valid?
  end

  def delimiter
    Rails.application.config.csv_mvf_delimiter
  end

  def module_and_profile_exist
    begin
      Lookup.module.registered_profiles.fetch(converter_profile)
    rescue Exception => ex
      errors.add(:invalid_module_or_profile, ex.backtrace)
    end
  end

  def set_module
    write_attribute :converter_module, Lookup.converter_module.capitalize
  end

  def add_authority(type:, subtype:, name:, identifier: nil, stub: false)
    converter = nil
    data = {}
    data[:batch]            = import_batch
    data[:profile]          = converter_profile
    data[:category]         = 'Authority' # need this if coming from procedure
    data[:type]             = type
    data[:subtype]          = subtype
    data[:identifier]       = identifier
    data[:title]            = name

    if stub
      converter = Lookup.default_authority_class(type)
      content_data = {
        "shortidentifier" => identifier,
        "termdisplayname" => name,
        "termtype"        => "#{CSIDF.authority_term_type(type)}Term",
      }
    else
      converter    = Lookup.authority_class(type)
      content_data = csv_data
    end

    data[:converter] = converter.to_s
    data[:identifier_field] = converter.service[:identifier_field]
    add_cspace_object(data, content_data)
  end

  def add_hierarchy
    converter  = Lookup.default_hierarchy_class
    type       = csv_data['type']
    subtype    = csv_data['subtype']
    narrower   = csv_data['narrower']
    broader    = csv_data['broader']
    identifier = [type, subtype, narrower, broader].compact.join('-')

    data = {}
    data[:batch]            = import_batch
    data[:profile]          = converter_profile
    data[:category]         = 'Relationship'
    data[:converter]        = converter.to_s
    data[:type]             = 'Hierarchy' # not the same as csv_data type
    data[:subtype]          = subtype
    data[:identifier_field] = converter.service[:identifier_field]
    data[:identifier]       = identifier
    data[:title]            = identifier

    content_data = {}
    content_data['subjectdocumenttype'] = subtype.nil? ? type : "#{type}item"
    content_data['objectdocumenttype']  = subtype.nil? ? type : "#{type}item"
    {'subject_csid' => narrower, 'object_csid' => broader}.each do |key, value|
      csid = find_csid(value, type, subtype)
      raise "Unable to find csid for #{identifier}" unless csid

      data[key.to_sym] = csid
      content_data[key.delete('_')] = csid
    end
    add_cspace_object(data, content_data)
  end

  def add_relationship
    converter = Lookup.default_relationship_class
    data = {}
    data[:batch]            = import_batch
    data[:profile]          = converter_profile
    data[:category]         = 'Relationship'
    data[:converter]        = converter.to_s
    data[:type]             = 'Relationship'
    data[:subtype]          = nil
    data[:identifier_field] = converter.service[:identifier_field]

    csids = { subject: {}, object: {} }
    csids.each do |type, _|
      csid = find_csid(
        csv_data["#{type}identifier"],
        csv_data["#{type}documenttype"]
      )
      raise "Unable to find csid for #{csv_data["#{type}identifier"]}" unless csid

      csids[type][:id] = csid
      csids[type][:type] = csv_data["#{type}documenttype"]
    end

    prepare_rlshp(data, csids[:subject], csids[:object])
    prepare_rlshp(data, csids[:object], csids[:subject])
  end

  def add_procedure(procedure, attributes)
    converter = Lookup.procedure_class(procedure)
    data = {}
    data[:batch]            = import_batch
    data[:profile]          = converter_profile
    data[:category]         = 'Procedure'
    data[:converter]        = converter.to_s
    data[:type]             = procedure
    data[:subtype]          = ''
    data[:identifier_field] = converter.service[:identifier_field]
    data[:identifier]       = csv_data[attributes["identifier"]]
    data[:title]            = csv_data[attributes["title"]]
    add_cspace_object(data, csv_data)
  end

  def add_vocabulary(type:, subtype:, name:, identifier: nil, stub: false)
    converter = Lookup.default_vocabulary_class
    data = {}
    data[:batch]            = import_batch
    data[:profile]          = converter_profile
    data[:category]         = 'Vocabulary' # need this if coming from procedure
    data[:type]             = type
    data[:subtype]          = subtype
    data[:identifier]       = identifier
    data[:title]            = name

    if stub
      content_data = {
        "shortidentifier" => name.downcase,
        "displayname"     => name,
      }
    else
      content_data = csv_data
    end

    data[:converter] = converter.to_s
    data[:identifier_field] = converter.service[:identifier_field]
    add_cspace_object(data, content_data)
  end

  def find_csid(id, type, subtype = nil)
    service = Lookup.record_class(type).service(subtype)
    id      = AuthCache.authority(service[:id], subtype, id) unless subtype.nil?
    return if id.nil?

    csid = CollectionSpaceObject.find_csid(type, id)
    csid || RemoteActionService.find_item_csid(service, id)
  end

  def prepare_rlshp(data, subj, obj)
    data[:identifier]   = "#{subj[:id]}-#{obj[:id]}"
    data[:title]        = data[:identifier]
    data[:subject_csid] = subj[:id]
    data[:object_csid]  = obj[:id]
    content_data = {
      'subjectcsid' => subj[:id],
      'subjectdocumenttype' => subj[:type],
      'objectcsid' => obj[:id],
      'objectdocumenttype' => obj[:type]
    }
    add_cspace_object(data, content_data)
  end
end
