class CollectionSpaceObject
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :data_object, counter_cache: true
  validate   :identifier_is_unique_per_type
  validates_uniqueness_of :fingerprint

  after_create :ping, unless: -> { has_csid_and_uri? }
  after_validation :log_errors, if: -> { errors.any? }
  before_validation :set_fingerprint

  field :batch,            type: String
  field :profile,          type: String
  field :category,         type: String # ex: Authority, Procedure
  field :converter,        type: String # ex: CollectionSpace::Converter::Core:CorePerson
  field :type,             type: String # ex: CollectionObject, Person
  field :subtype,          type: String # ex: person [auth only]
  field :identifier_field, type: String
  field :identifier,       type: String
  field :title,            type: String
  field :content,          type: String
  field :fingerprint,      type: String
  # fields from remote collectionspace
  field :csid,             type: String
  field :uri,              type: String
  # field for relations only
  field :subject_csid,     type: String
  field :object_csid,      type: String

  attr_readonly :type
  scope :transferred, ->{ where(csid: true) } # TODO: check
  index(
    { category: 1, identifier: 1 }, { name: 'category_identifier_index', unique: true }
  )
  index({ batch: 1, type: 1 }, { name: 'batch_type_index' })

  def generate_content!(data = nil)
    data ||= data_object.csv_data
    config = converter.constantize.service(subtype)
    config[:identifier] = identifier
    config[:title] = title
    data = Lookup.profile_defaults(profile).merge(data)
    cvtr = converter.constantize.new(data, config)
    Rails.logger.debug(
      "Generating content for: #{converter} -- #{data}, #{config}"
    )
    write_attribute 'content', cvtr.convert
  end

  def has_csid_and_uri?
    !!(csid and uri)
  end

  def is_authority?
    category == 'Authority'
  end

  def is_procedure?
    category == 'Procedure'
  end

  def is_relationship?
    category == 'Relationship'
  end

  def is_vocabulary?
    category == 'Vocabulary'
  end

  def set_fingerprint
    parts = Lookup.parts_for(category).parts
    return unless parts.any?
    parts = parts.map { |p| read_attribute(p) }
    write_attribute 'fingerprint', Fingerprint.generate(parts)
  end

  def self.find_csid(type, identifier)
    object = CollectionSpaceObject.where(type: type, identifier: identifier).first
    object ? object.csid : nil
  end

  def self.has_authority?(identifier)
    CollectionSpaceObject.where(category: 'Authority', identifier: identifier).count.positive?
  end

  def self.has_identifier?(identifier)
    CollectionSpaceObject.where(identifier: identifier).count.positive?
  end

  def self.has_procedure?(identifier)
    CollectionSpaceObject.where(category: 'Procedure', identifier: identifier).count.positive?
  end

  def self.has_vocabulary?(identifier)
    CollectionSpaceObject.where(category: 'Vocabulary', identifier: identifier).count.positive?
  end

  private

  def identifier_is_unique_per_type
    if CollectionSpaceObject.where(type: type, identifier: identifier).count > 1
      errors.add(:uniqueness, message: "Identifier must be unique per type:#{type};#{identifier}")
    end
  end

  def log_errors
    logger.warn errors.full_messages.append([attributes.inspect]).join("\n")
  end

  def ping
    if Lookup.async?
      PingJob.perform_later(id.to_s)
    else
      PingJob.perform_now(id.to_s)
    end
  end
end
