class Batch
  include Mongoid::Document
  include Mongoid::Locker
  validates_presence_of :key
  validates_uniqueness_of :key
  before_destroy { |batch| DataObject.where(import_batch: batch.name).destroy_all }

  field :key,       type: String
  field :category,  type: String
  field :type,      type: String
  field :for,       type: String
  field :name,      type: String
  field :processed, type: Integer, default: 0
  field :failed,    type: Integer, default: 0
  field :total,     type: Integer, default: 0
  field :start,     type: DateTime, default: Time.now
  field :end,       type: DateTime

  index({ key: 1 }, { name: 'key_index', unique: true })

  # lock fields
  field :locking_name, type: String
  field :locked_at,    type: Time
  index(
    { _id: 1, locking_name: 1 },
    name: 'batch_locker_index',
    sparse: true,
    unique: true
  )

  def self.retrieve(key)
    Batch.where(key: key).first
  end
end
