class CacheService
  def self.authorities
    Lookup.module.registered_authorities
  end

  def self.cache_dir
    File.join(ENV['HOME'], '.cspace-converter')
  end

  def self.cache_file
    File.join(cache_dir, "#{Lookup.converter_remote_host}.csv")
  end

  def self.cache_date_file
    File.join(cache_dir, "#{Lookup.converter_remote_host}.txt")
  end

  def self.csv_headers
    [
      'refname',
      'name',
      'identifier',
      'parent_refname',
      'parent_rev',
      'type',
      'subtype',
      'key'
    ]
  end

  def self.download_authorities
    download(
      ['refName', 'termDisplayName', 'shortIdentifier', 'workflowState'],
      authorities
    )
  end

  def self.download_vocabularies
    download(
      ['refName', 'displayName', 'shortIdentifier', 'workflowState'],
      ['vocabularies']
    )
  end

  def self.download(headers, endpoints)
    endpoints.each do |endpoint|
      Rails.logger.debug "Processing endpoint: #{endpoint}"
      $collectionspace_client.all(endpoint).each do |list|
        list_refname = list['refName']
        list_rev     = list['rev']
        next if CacheObject.skip_list?(list_refname, list_rev)

        Rails.logger.debug "Processing list: #{list_refname}, #{list_rev}"
        $collectionspace_client.config.include_deleted = true
        $collectionspace_client.all("#{list['uri']}/items").each do |item|
          refname, name, identifier, wfstate = item.values_at(*headers)
          next unless refname

          item = CacheObject.item?(refname)
          if wfstate == 'deleted'
            CacheObject.where(refname: refname).first.destroy if item
            next # don't add to cache if deleted
          end
          next if item #  don't add to cache if already in cache

          Rails.logger.debug "Cache: #{refname}"
          CacheObject.create(
            refname: refname,
            name: name,
            identifier: identifier,
            parent_refname: list_refname,
            parent_rev: list_rev.to_i
          )
        end
        $collectionspace_client.config.include_deleted = false
      end
    end
  end

  def self.export
    Rails.logger.info "Exporting cache: #{cache_file}"

    cache_tmp_file = "#{cache_file}.#{Time.now.to_i}.tmp"
    headers = CacheService.csv_headers
    CSV.open(cache_tmp_file, 'a') do |csv|
      csv << headers
    end

    CacheObject.all.each do |object|
      CSV.open(cache_tmp_file, 'a') do |csv|
        csv << object.attributes.values_at(*headers)
      end
    end
    FileUtils.mv cache_tmp_file, cache_file
  end

  def self.import
    return unless File.file? cache_file
    return unless CacheObject.count.zero?

    Rails.logger.info "Loading cache: #{cache_file}"
    tracker = 1
    SmarterCSV.process(File.open(cache_file, 'r:bom|utf-8'), {
      chunk_size: 100,
      convert_values_to_numeric: true,
      required_headers: csv_headers.map(&:to_sym)
    }.merge(Rails.application.config.csv_parser_options)) do |chunk|
      Rails.logger.debug("Processing chunk: #{tracker}")
      CacheObject.collection.insert_many(chunk)
      tracker += 1
    end
  end

  def self.invalidate
    unless File.file? cache_date_file
      FileUtils.rm_f cache_file
      File.open(cache_date_file, 'w') { |f| f.write Time.now }
    end

    cached_date = DateTime.parse(File.read(cache_date_file))
    remote_date = DateTime.parse(system_setup_date)
    if remote_date > cached_date
      Rails.logger.warn 'Deleting cache as remote system may have been reset.'
      FileUtils.rm_f cache_file
    end
  end

  def self.refresh
    FileUtils.mkdir_p cache_dir
    invalidate
    import
    download_vocabularies
    download_authorities
    export
  end

  def self.system_setup_date
    $collectionspace_client.get(
      'personauthorities/urn:cspace:name(person)'
    ).parsed['document']['collectionspace_core']['createdAt']
  end
end
