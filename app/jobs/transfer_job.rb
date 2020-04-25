class TransferJob < ActiveJob::Base
  queue_as :default

  def perform(action, type, batch_name, key)
    CollectionSpaceObject.batch_size(
      ENV.fetch('CSPACE_CONVERTER_TRANSFER_BATCH_SIZE', 25)
    ).where(type: type, batch: batch_name).pluck(:id).each do |id|
      if Lookup.async?
        RemoteJob.perform_later(action, key, id.to_s)
      else
        RemoteJob.perform_now(action, key, id.to_s)
      end
    end
  end
end
