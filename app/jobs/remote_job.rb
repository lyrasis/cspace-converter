class RemoteJob < ActiveJob::Base
  queue_as :default

  def perform(action_method, batch_id, object_id)
    batch  = Batch.find(batch_id)
    object = CollectionSpaceObject.find(object_id)
    begin
      service = RemoteActionService.new(object)
      if !object.is_relationship? && !object.has_csid_and_uri?
        service.remote_ping # update csid and uri if object is found
      end
      status = service.send(action_method.to_sym)
      status.ok ? batch.processed += 1 : batch.failed += 1
    rescue StandardError
      batch.failed += 1
    end
    batch.save
    if batch.finished?
      batch.status = 'complete'
      batch.end = Time.now
      batch.save
    end
  end
end
