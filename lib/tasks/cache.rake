namespace :cache do
  # bundle exec rake cache:clear
  task :clear => :environment do |t, args|
    Rails.cache.clear
  end

  # bundle exec rake cache:download_authorities
  task :download_authorities => :environment do |t, args|
    CacheService.download_authorities
  end

  # bundle exec rake cache:download_vocabularies
  task :download_vocabularies => :environment do |t, args|
    CacheService.download_vocabularies
  end

  # bundle exec rake cache:export[~/.cspace-converter,cache.csv]
  task :export, [:path, :file] => :environment do |t, args|
    path = File.expand_path args[:path]
    file = args[:file]
    raise "Invalid path #{path}" unless File.directory? path

    headers = CacheService.csv_headers
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

    headers = CacheService.csv_headers

    CSV.foreach(file, headers: true) do |row|
      refname, name, identifier, rev, parent_refname, parent_rev = row.values_at(*headers)
      CacheObject.create(
        refname: refname,
        name: name,
        identifier: identifier,
        rev: rev,
        parent_refname: parent_refname,
        parent_rev: parent_rev
      )
    end
  end
end
