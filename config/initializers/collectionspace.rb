# Require the DEFAULT module
Dir["#{Rails.root.join('lib', 'collectionspace', 'converter', 'default')}/*.rb"].each do |lib|
  require lib
end

# Require everything else (starting with "_*")
Dir["#{Rails.root.join('lib', 'collectionspace')}/**/*.rb"].sort.each do |lib|
  require lib
end

CacheService.refresh unless ENV.key?('CACHE_REFRESH_SKIP')
