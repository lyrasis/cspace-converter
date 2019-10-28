class CacheService
  def self.authorities
    Lookup.converter_class.registered_authorities
  end

  def self.cache_dir
    File.join(ENV['HOME'], '.cspace-converter')
  end

  def self.cache_file
    File.join(cache_dir, "#{Lookup.converter_domain}.csv")
  end

  def self.csv_headers
    [
      'refname',
      'name',
      'identifier',
      'rev',
      'parent_refname',
      'parent_rev'
    ]
  end

  def self.download_authorities
    download(
      ['refName', 'termDisplayName', 'shortIdentifier', 'rev'],
      authorities
    )
  end

  def self.download_vocabularies
    download(
      ['refName', 'displayName', 'shortIdentifier', 'rev'],
      ['vocabularies']
    )
  end

  def self.download(headers, endpoints)
    endpoints.each do |endpoint|
      $collectionspace_client.all(endpoint).each do |list|
        list_refname = list['refName']
        list_rev     = list['rev']
        next if CacheObject.skip_list?(list_refname, list_rev)

        $collectionspace_client.all("#{list['uri']}/items").each do |item|
          refname, name, identifier, rev = item.values_at(*headers)
          next if CacheObject.skip_item?(refname, rev)

          Rails.logger.debug "Cache: #{refname}"
          CacheObject.create(
            refname: refname,
            name: name,
            identifier: identifier,
            rev: rev,
            parent_refname: list_refname,
            parent_rev: list_rev
          )
        end
      end
    end
  end

  def self.export
    FileUtils.mkdir_p cache_dir
    FileUtils.rm_f cache_file

    Rails.logger.info "Exporting cache: #{cache_file}"

    headers = CacheService.csv_headers
    CSV.open(cache_file, 'a') do |csv|
      csv << headers
    end

    CacheObject.all.each do |object|
      CSV.open(cache_file, 'a') do |csv|
        csv << object.attributes.values_at(*headers)
      end
    end
  end

  def self.import
    return unless File.file? cache_file

    Rails.logger.info "Loading cache: #{cache_file}"

    headers = CacheService.csv_headers
    CSV.foreach(cache_file, headers: true) do |row|
      CacheObject.create(row.to_hash)
    end
  end

  def refresh
    import
    download_vocabularies
    download_authorities
    export
  end
end
