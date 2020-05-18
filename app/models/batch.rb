# frozen_string_literal: true

class Batch
  include Mongoid::Document
  include Mongoid::Locker
  before_destroy :cleanup, if: proc { |b| b.type == 'import' }
  validates :name, uniqueness: { scope: :type }, if: proc { |b| b.type == 'import' }
  validates_presence_of :key, :for, :name
  validates_uniqueness_of :key

  field :key,       type: String
  field :category,  type: String
  field :type,      type: String
  field :for,       type: String
  field :name,      type: String
  field :processed, type: Integer, default: 0
  field :failed,    type: Integer, default: 0
  field :succeeded, type: Integer, default: 0
  field :total,     type: Integer, default: 0
  field :start,     type: DateTime, default: Time.now
  field :end,       type: DateTime

  index({ name: 1, type: 1 }, { name: 'name_type_index' })
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

  def cleanup
    Batch.where(name: name, :type.ne => 'import').destroy_all
    DataObject.where(import_batch: name).destroy_all
  end

  def self.retrieve(key)
    Batch.where(key: key).first
  end
end
