# frozen_string_literal: true

module DataObjectsHelper
  def current_page_params
    request.params.slice('batch', 'errors', 'filters', 'page')
  end

  def identifier_for(object)
    if object.read_attribute(:identify_by_column)
      object.csv_data.fetch(object.identify_by_column, object.id)
    else
      object.id
    end
  end

  def object_label(object)
    "#{object.id} #{object.import_batch} #{object.converter_module} #{object.converter_profile}"
  end

  def status_for(object)
    object.import_status.zero? ? 'fail' : 'ok'
  end
end
