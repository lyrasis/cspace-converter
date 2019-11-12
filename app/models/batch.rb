class Batch
  include Mongoid::Document
  validates_presence_of :key
  validates_uniqueness_of :key
  before_destroy { |batch| DataObject.where(import_batch: batch.name).destroy_all }

  field :key,       type: String
  field :category,  type: String
  field :type,      type: String
  field :for,       type: String
  field :name,      type: String
  field :status,    type: String, default: 'waiting'
  field :processed, type: Integer, default: 0
  field :failed,    type: Integer, default: 0
  field :start,     type: DateTime, default: Time.now
  field :end,       type: DateTime

  def self.retrieve(key)
    Batch.where(key: key).first
  end
end
