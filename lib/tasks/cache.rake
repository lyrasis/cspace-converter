namespace :cache do
  CSV_HEADERS = ['refname', 'name', 'identifier']

  def download(headers, endpoints)
    endpoints.each do |endpoint|
      $collectionspace_client.all(endpoint).each do |list|
        list_uri = list['uri']
        list_updated_at = list['updated_at']
        next if CacheObject.skip_list?(list_uri, list_updated_at)

        $collectionspace_client.all("#{list_uri}/items").each do |item|
          item_uri = item['uri']
          item_updated_at = item['updated_at']
          next if CacheObject.skip_item?(item_uri, item_updated_at)

          Rails.logger.debug item_uri
          refname, name, identifier = item.values_at(*headers)
          CacheObject.create(
            uri: item_uri,
            refname: refname,
            name: name,
            identifier: identifier,
            updated_at: item_updated_at,
            parent_uri: list_uri,
            parent_upated_at: list_updated_at
          )
        end
      end
    end
  end

  # bundle exec rake cache:clear
  task :clear => :environment do |t, args|
    Rails.cache.clear
  end

  # bundle exec rake cache:download_authorities
  task :download_authorities => :environment do |t, args|
    authorities = Lookup.converter_class.registered_authorities
    download(
      ['refName', 'termDisplayName', 'shortIdentifier'],
      authorities
    )
  end

  # bundle exec rake cache:download_vocabularies
  task :download_vocabularies => :environment do |t, args|
    download(
      ['refName', 'displayName', 'shortIdentifier'],
      ['vocabularies']
    )
  end

  # bundle exec rake cache:export[~/.cspace-converter,cache.csv]
  task :export, [:path, :file] => :environment do |t, args|
    path = File.expand_path args[:path]
    file = args[:file]
    raise "Invalid path #{path}" unless File.directory? path

    headers = CSV_HEADERS
    output  = File.join(path, file)
    FileUtils.rm_f output

    CSV.open(output, 'a') do |csv|
      csv << headers
    end

    CacheObject.all.each do |object|
      CSV.open(output, 'a') do |csv|
        csv << object.attributes.values_at(*headers)
      end
    end
  end

  # bundle exec rake cache:import[~/.cspace-converter/cache.csv]
  task :import, [:file] => :environment do |t, args|
    file = File.expand_path args[:file]
    raise "Invalid file #{file}" unless File.file? file

    headers = CSV_HEADERS

    CSV.foreach(file, headers: true) do |row|
      refname, name, identifier = row.values_at(*headers)
      CacheObject.create(
        refname: refname,
        name: name,
        identifier: identifier
      )
    end
  end
end
