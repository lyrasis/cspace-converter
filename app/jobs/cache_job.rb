class CacheJob < ActiveJob::Base
  queue_as :default

  def perform
    CacheService.refresh
  end
end
