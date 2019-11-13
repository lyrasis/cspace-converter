class TransferJob < ActiveJob::Base
  queue_as :default

  def perform(action, type, batch_name, key)
    action_method = TransferJob.actions action
    raise "Invalid remote action #{action}!" unless action_method

    batch = Batch.retrieve(key)
    batch.status = 'running' # reset running status
    batch.total = CollectionSpaceObject.where(type: type, batch: batch_name).count
    batch.save

    CollectionSpaceObject.batch_size(
      ENV.fetch('CSPACE_CONVERTER_TRANSFER_BATCH_SIZE', 25)
    ).where(type: type, batch: batch_name).each do |object|
      RemoteJob.perform_later(action_method, batch.id.to_s, object.id.to_s)
    end
  end

  def self.actions(action)
    {
      "delete" => "remote_delete",
      "transfer" => "remote_transfer",
      "update" => "remote_update",
    }.fetch(action, action)
  end
end
