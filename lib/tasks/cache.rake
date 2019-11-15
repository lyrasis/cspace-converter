namespace :cache do
  # bundle exec rake cache:download_authorities
  task :download_authorities => :environment do |t, args|
    CacheService.download_authorities
  end

  # bundle exec rake cache:download_vocabularies
  task :download_vocabularies => :environment do |t, args|
    CacheService.download_vocabularies
  end

  # bundle exec rake cache:export
  task :export => :environment do
    CacheService.export
  end

  # bundle exec rake cache:import
  task :import => :environment do
    CacheService.import
  end

  # bundle exec rake cache:refresh
  task :refresh => :environment do
    CacheService.refresh
  end
end
