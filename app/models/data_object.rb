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

  def converter_class
    Lookup.converter_class
  end

  def delimiter
    Rails.application.config.csv_mvf_delimiter
  end

  def module_and_profile_exist
    begin
      converter_class.registered_profiles.fetch(converter_profile)
    rescue Exception => ex
      errors.add(:invalid_module_or_profile, ex.backtrace)
    end
  end

  def set_module
    write_attribute :converter_module, Lookup.converter_module.capitalize
  end

  def add_authority(type:, subtype:, name:, identifier: nil, from_procedure: false)
    converter = nil
    data = {}
    data[:batch]            = import_batch
    data[:profile]          = converter_profile
    data[:category]         = 'Authority' # need this if coming from procedure
    data[:type]             = type
    data[:subtype]          = subtype
    data[:identifier]       = identifier
    data[:title]            = name

    if from_procedure
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

    service = Lookup.record_class(type).service(subtype)
    content_data = {}
    if subtype.nil?
      content_data['subjectdocumenttype'] = type
      content_data['objectdocumenttype']  = type
    else
      content_data['subjectdocumenttype'] = "#{type}item"
      content_data['objectdocumenttype']  = "#{type}item"
    end
    {'subjectcsid' => narrower, 'objectcsid' => broader}.each do |key, value|
      value = AuthCache.authority(service[:id], subtype, value) unless subtype.nil?
      csid  = CollectionSpaceObject.find_csid(type, value)
      csid ||= RemoteActionService.find_csid(service, value)
      raise "Unable to find csid for #{identifier}" unless csid

      content_data[key] = csid
    end
    add_cspace_object(data, content_data)
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

  def add_vocabulary(type:, subtype:, name:, identifier: nil, from_procedure: false)
    converter = Lookup.default_vocabulary_class
    data = {}
    data[:batch]            = import_batch
    data[:profile]          = converter_profile
    data[:category]         = 'Vocabulary' # need this if coming from procedure
    data[:type]             = type
    data[:subtype]          = subtype
    data[:identifier]       = identifier
    data[:title]            = name

    if from_procedure
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
end
