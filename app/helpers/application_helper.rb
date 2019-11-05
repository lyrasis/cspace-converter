module ApplicationHelper

  def batches
    DataObject.pluck('import_batch').uniq
  end

  def collectionspace_base_uri
    Rails.application.secrets[:collectionspace_base_uri]
  end

  def collectionspace_domain
    Rails.application.config.domain
  end

  def collectionspace_username
    Rails.application.secrets[:collectionspace_username]
  end

  def converter_module
    Lookup.converter_module
  end

  def path_for_batch_type(batch)
    if batch.type == 'TransferJob'
      return batches_path
    else
      return objects_path(batch: batch.name)
    end
  end

  def profiles
    profiles = []
    Lookup.converter_class.registered_profiles.keys.sort.each do |profile|
      profiles << [profile, profile, class: Lookup.converter_module]
    end
    profiles
  end

  def disabled_profiles
    Lookup.converter_class.registered_profiles.find_all do |_, profile|
      !profile.fetch('enabled', false)
    end.map{ |p| p[0] }
  end

  def types
    CollectionSpaceObject.pluck('type').uniq
  end

  def short_date(date)
    date.to_s(:short)
  end

end
