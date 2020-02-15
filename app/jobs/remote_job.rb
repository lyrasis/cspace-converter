class RemoteJob < ActiveJob::Base
  queue_as :default

  def perform(action_method, key, object_id)
    object = CollectionSpaceObject.find(object_id)
    begin
      service = RemoteActionService.new(object)
      service.remote_ping unless object.has_csid_and_uri?
      status = service.send(action_method.to_sym)
    rescue StandardError
      status = RemoteActionService::Status.new
    end
    object.transfer_statuses.create(
      transfer_status: status.ok,
      transfer_message: status.message
    )
    batch = Batch.retrieve(key)
    batch.with_lock do
      batch.processed += 1
      batch.failed += 1 unless status.ok
      batch.end = Time.now
      batch.save
    end
  end
end
