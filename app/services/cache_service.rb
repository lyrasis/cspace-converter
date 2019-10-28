class CacheService
  def self.authorities
    Lookup.converter_class.registered_authorities
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
  end

  def self.import
  end
end