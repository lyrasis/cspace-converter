class CacheObject
  include Mongoid::Document
  validates_uniqueness_of :key, :refname

  before_validation :setup

  field :uri,        type: String
  field :refname,    type: String
  field :name,       type: String
  field :identifier, type: String
  field :type,       type: String
  field :subtype,    type: String
  field :key,        type: String
  field :rev,        type: Integer

  # parent vocabulary
  field :parent_refname, type: String
  field :parent_rev,     type: Integer

  index({ refname: 1 }, { name: 'refname_index', unique: true })
  index({ parent_refname: 1 }, { name: 'parent_refname_index' })

  def setup
    type    = CSURN.parse_type(refname)
    subtype = CSURN.parse_subtype(refname)
    key     = AuthCache.cache_key([type, subtype, name])
    write_attribute :type, type
    write_attribute :subtype, subtype
    write_attribute :key, key
  end

  def self.item?(refname)
    CacheObject.where(refname: refname).count.positive?
  end

  def self.skip_list?(refname, rev)
    CacheObject.where(
      parent_refname: refname, :parent_rev.gte => rev
    ).count.positive?
  end
end
