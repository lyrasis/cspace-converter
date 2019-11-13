namespace :remote do
  task :delete, [:type, :batch] => :environment do |t, args|
    type       = args[:type]
    batch      = args[:batch]
    remote_action_process "delete", type, batch
  end

  # bundle exec rake remote:get[acquisitions]
  task :get, [:path] => :environment do |t, args|
    path = args[:path]
    puts $collectionspace_client.get(path).xml
  end

  task :transfer, [:type, :batch] => :environment do |t, args|
    type       = args[:type]
    batch      = args[:batch]
    remote_action_process "transfer", type, batch
  end

  task :update, [:type, :batch] => :environment do |t, args|
    type       = args[:type]
    batch      = args[:batch]
    remote_action_process "update", type, batch
  end

  def remote_action_process(action, type, batch)
    start_time = Time.now
    Rails.logger.debug "Starting remote #{action} job at #{start_time}."
    key = SecureRandom.uuid
    Batch.create(
      key: key,
      category: 'transfer',
      type: action,
      for: type,
      name: batch,
      start: Time.now
    )

    TransferJob.perform_now(action, type, batch, key)
    end_time = Time.now
    Rails.logger.debug "Remote #{action} job completed at #{end_time}."
  end
end
