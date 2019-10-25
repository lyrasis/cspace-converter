class ImportService

  class Base
    attr_reader :data, :object, :profile
    def initialize(profile, data)
      @data    = data
      @object  = nil
      @profile = profile
    end

    def add_authority(name_field, type, subtype, from_procedure = false)
      term_display_name = object.object_data[name_field]
      return unless term_display_name

      service = Lookup.record_class(type).service(subtype)
      service_id = service[:id]

      term_display_name.split(object.delimiter).map(&:strip).each do |name|
        identifier = AuthCache.authority service_id, subtype, name
        next if identifier && from_procedure # skip cached from procedure

        # override identifier with shortidentifier if available
        identifier = object.object_data.fetch('shortidentifier', identifier)
        identifier ||= CSIDF.short_identifier(name)

        next if CollectionSpaceObject.has_authority?(identifier)

        object.add_authority(
          type: type,
          subtype: subtype,
          name: name,
          identifier: identifier,
          from_procedure: from_procedure
        )
        object.save!
      end
    end

    def create_object
      @object = DataObject.new.from_json(JSON.generate(data))
      @object.save!
    end

    def process
      raise 'Error: must be implemented in subclass'
    end

    def update_status(import_status:, import_message:)
      raise 'Data Object has not been created' unless object

      object.write_attributes(
        import_status: import_status,
        import_message: import_message
      )
      object.save!
    end
  end

  class Authorities < Base
    def initialize(profile, data)
      super
    end

    def process
      raise 'Data Object has not been created' unless object

      config = Lookup.profile_config(profile)
      add_authority(
        config['name_field'],
        config['authority_type'],
        config['authority_subtype'],
        false
      )
    end
  end

  class Procedures < Base
    def initialize(profile, data)
      super
    end

    def add_related_authorities(authorities)
      authorities.each do |attributes|
        name_field, type, subtype = gather_authority_data(attributes)
        next unless type

        add_authority(name_field, type, subtype, true)
      end
    end

    def gather_authority_data(attributes)
      name_field = attributes['name_field']

      if attributes['authority_type_from']
        type = object.object_data[attributes['authority_type_from']]
      end
      type ||= attributes['authority_type']
      type = type.capitalize if type

      subtype = attributes['authority_subtype'] ||= type.downcase
      [name_field, type, subtype]
    end

    def process
      raise 'Data Object has not been created' unless object

      config = Lookup.profile_config(profile)
      config.each do |procedure, attributes|
        next if procedure == 'Authorities'

        object.add_procedure procedure, attributes
        object.save!
      end
      add_related_authorities(config.fetch('Authorities', {}))
    end
  end
end
