class ImportService
  class Base
    attr_reader :data, :object, :profile
    def initialize(profile, data)
      @data    = data
      @object  = nil
      @profile = profile
    end

    def add_authority(name_field:, type:, subtype:)
      display_name = object.csv_data[name_field]
      return unless display_name

      service = Lookup.record_class(type).service(subtype)[:id]
      names_for(display_name).each do |name|
        identifier = identifier_for(:authority, service, subtype, name)
        next if identifier.nil?

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

    def add_vocabulary(name_field:, subtype:)
      display_name = object.csv_data[name_field]
      return unless display_name

      names_for(display_name).each do |name|
        identifier = identifier_for(:vocabulary, 'vocabularies', subtype, name)
        next if identifier.nil?

        object.add_vocabulary(
          type: 'Vocabulary',
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

    def identifier_for(method, type, subtype, name)
      identifier = if method == :authority
        AuthCache.authority(type, subtype, name)
      elsif method == :vocabulary
        AuthCache.vocabulary(subtype, name)
      end
      # we don't want to create a stub record
      return nil if identifier && from_procedure

      identifier = object.csv_data.fetch('shortidentifier', identifier)
      identifier || CSIDF.short_identifier(name)
    end

    def names_for(display_name)
      display_name.split(object.delimiter).map(&:strip)
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
    attr_reader :from_procedure
    def initialize(profile, data)
      super
      @from_procedure = false
    end

    def process
      raise 'Data Object has not been created' unless object

      config = Lookup.profile_config(profile)
      add_authority(
        name_field: config['name_field'],
        type: config['authority_type'],
        subtype: config['authority_subtype']
      )
    end
  end

  class Hierarchies < Base
    attr_reader :from_procedure
    def initialize(profile, data)
      super
      @from_procedure = false
    end

    def process
      raise 'Data Object has not been created' unless object

      object.add_hierarchy
    end
  end

  class Procedures < Base
    attr_reader :from_procedure
    def initialize(profile, data)
      super
      @from_procedure = true
    end

    def add_related_authorities(authorities)
      authorities.each do |attributes|
        name_field, type, subtype = gather_authority_data(attributes)
        next unless type

        add_authority(
          name_field: name_field,
          type: type,
          subtype: subtype
        )
      end
    end

    def add_related_vocabularies(vocabularies)
      vocabularies.each do |attributes|
        add_vocabulary(
          name_field: attributes['name_field'],
          subtype: attributes['vocabulary_subtype'],
        )
      end
    end

    def gather_authority_data(attributes)
      name_field = attributes['name_field']

      if attributes['authority_type_from']
        type = object.csv_data[attributes['authority_type_from']]
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
        next if ['Authorities', 'Vocabularies'].include?(procedure)

        object.add_procedure procedure, attributes
        object.save!
      end
      add_related_authorities(config.fetch('Authorities', {}))
      add_related_vocabularies(config.fetch('Vocabularies', {}))
    end
  end

  class Relationships < Base
    attr_reader :from_procedure
    def initialize(profile, data)
      super
      @from_procedure = false
    end

    def process
      raise 'Data Object has not been created' unless object

      object.add_relationship
    end
  end

  class Vocabularies < Base
    attr_reader :from_procedure
    def initialize(profile, data)
      super
      @from_procedure = false
    end

    def process
      raise 'Data Object has not been created' unless object

      config = Lookup.profile_config(profile)
      add_vocabulary(
        name_field: config['name_field'],
        subtype: object.csv_data['vocabulary']
      )
    end
  end
end
