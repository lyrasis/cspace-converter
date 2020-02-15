# frozen_string_literal: true

class TransferStatus
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :collection_space_object, counter_cache: true
  field :transfer_message,    type: String
  field :transfer_status,     type: Boolean
end
