class RemoteJob < ActiveJob::Base
  queue_as :default

  def perform(action_method, key, object_id)
    object = CollectionSpaceObject.find(object_id)
    begin
      service = RemoteActionService.new(object)
      if !object.is_relationship? && !object.has_csid_and_uri?
        service.remote_ping # update csid and uri if object is found
      end
      status = service.send(action_method.to_sym)
    rescue StandardError
      status = RemoteActionService::Status.new
    end
    batch = Batch.retrieve(key)
    batch.with_lock do
      status.ok ? batch.processed += 1 : batch.failed += 1
      batch.end = Time.now
      batch.save
    end
  end
end