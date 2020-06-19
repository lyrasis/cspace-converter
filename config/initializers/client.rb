# Set the global CollectionSpace Client constant

$collectionspace_client = CollectionSpace::Client.new(
  CollectionSpace::Configuration.new(
    base_uri: Rails.application.secrets[:collectionspace_base_uri],
    username: Rails.application.secrets[:collectionspace_username],
    password: Rails.application.secrets[:collectionspace_password],
    page_size: 50,
    include_deleted: false,
    throttle: 0.10,
    verify_ssl: false,
  )
)

$collectionspace_cache = CollectionSpace::RefCache.new(
  config: {
    domain: "#{ENV.fetch('CSPACE_CONVERTER_DB_NAME')}_#{ENV['RAILS_ENV']}",
    error_if_not_found: false,
    lifetime: ENV['RAILS_ENV'] != 'test' ? 60 * 60 : 1,
    search_delay: ENV['RAILS_ENV'] != 'test' ? 5 * 60 : 0,
    search_enabled: ENV['RAILS_ENV'] != 'test',
    search_identifiers: false
  },
  client: $collectionspace_client
)
