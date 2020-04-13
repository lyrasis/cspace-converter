namespace :remote do
  namespace :batch do
    task :delete, [:type, :batch] => :environment do |t, args|
      type       = args[:type]
      batch      = args[:batch]
      remote_action_process "delete", type, batch
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
        start: Time.now,
        total: CollectionSpaceObject.where(type: type, batch: batch).count
      )

      TransferJob.perform_now(action, type, batch, key)
      end_time = Time.now
      Rails.logger.debug "Remote #{action} job completed at #{end_time}."
    end
  end

  namespace :client do
    # bundle exec rake remote:client:all[acquisitions]
    task :all, [:path] => :environment do |t, args|
      path = args[:path]
      $collectionspace_client.all(path).each { |item| puts item }
    end

    # bundle exec rake remote:client:delete[CollectionObject,ABC.123]
    task :delete, [:type, :identifier] => :environment do |t, args|
      type = args[:type]
      identifier = args[:identifier]
      request(type, identifier, :remote_delete)
    end

    # bundle exec rake remote:client:get[acquisitions]
    task :get, [:path] => :environment do |t, args|
      path = args[:path]
      puts $collectionspace_client.get(path).xml
    end

    # bundle exec rake remote:client:ping[CollectionObject,ABC.123]
    task :ping, [:type, :identifier] => :environment do |t, args|
      type = args[:type]
      identifier = args[:identifier]
      request(type, identifier, :remote_ping)
    end

    # bundle exec rake remote:client:transfer[CollectionObject,ABC.123]
    task :transfer, [:type, :identifier] => :environment do |t, args|
      type = args[:type]
      identifier = args[:identifier]
      request(type, identifier, :remote_transfer)
    end

    # bundle exec rake remote:client:update[CollectionObject,ABC.123]
    task :update, [:type, :identifier] => :environment do |t, args|
      type = args[:type]
      identifier = args[:identifier]
      request(type, identifier, :remote_update)
    end

    def request(type, identifier, action)
      obj = CollectionSpaceObject.where(
        type: type,
        identifier: identifier
      ).first
      abort("CollectionSpaceObject not found for identifier: #{identifier}") unless identifier
      status = RemoteActionService.new(obj).send(action)
      obj.transfer_statuses.create(
        transfer_status: status.ok,
        transfer_message: status.message
      )
    end
  end
end
