# frozen_string_literal: true

module ApplicationHelper
  def batches
    DataObject.pluck('import_batch').uniq
  end

  def category_path(category)
    "#{category.downcase}_path".to_sym
  end

  def collectionspace_base_uri
    Rails.application.secrets[:collectionspace_base_uri]
  end

  def collectionspace_domain
    Lookup.converter_domain
  end

  def collectionspace_username
    Rails.application.secrets[:collectionspace_username]
  end

  def converter_module
    Lookup.converter_module
  end

  def disabled_profiles
    Lookup.module.registered_profiles.find_all do |_, profile|
      !profile.fetch('enabled', false)
    end.map { |p| p[0] }
  end

  def path_for_batch_type(batch)
    if batch.type != 'import'
      URI.encode(File.join('batches', batch.name, batch.for))
    else
      objects_path(batch: batch.name)
    end
  end

  def profiles
    profiles = []
    Lookup.module.registered_profiles.keys.sort.each do |profile|
      profiles << [profile, profile, class: Lookup.converter_module]
    end
    profiles
  end

  def transfer_statuses_for(object)
    object.transfer_statuses.order(created_at: :desc).limit(3)
  end

  def short_date(date)
    return '' unless date

    date.to_s(:short)
  end

  def version
    version = ENV.fetch('BUILD_VERSION', 'dev')
    date = ENV.fetch('BUILD_DATE', Date.today)
    "Version: #{version} (#{date})"
  end
end
