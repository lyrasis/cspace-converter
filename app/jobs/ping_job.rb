class PingJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    RemoteActionService.new(CollectionSpaceObject.find(id)).ping
  end
end
