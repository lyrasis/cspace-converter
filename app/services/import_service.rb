class ImportService

  class Base
    attr_reader :data, :object, :profile, :type
    def initialize(profile, data)
      @data    = data
      @object  = nil
      @profile = profile
      @type    = nil
    end

    def add_authority(identifier_field, type, subtype, from_procedure = false)
      term_display_name = object.object_data[identifier_field]
      return unless term_display_name

      service = Lookup.service_class.get type, subtype
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
      object.save!
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
      @type = 'Authorities'
    end

    def process
      raise 'Data Object has not been created' unless object

      Lookup.profile_for(profile, type).each do |_, attributes|
        add_authority(
          attributes['identifier_field'],
          attributes['authority_type'],
          attributes['authority_subtype'],
          false
        )
      end
    end
  end

  class Procedures < Base
    def initialize(profile, data)
      super
      @type = 'Procedures'
    end

    def add_related_authorities(authorities)
      authorities.each do |authority, fields|
        fields.each do |field|
          authority_subtype = authority.downcase

          # if value pair first is the field and second is the specific authority (sub)type
          if field.respond_to? :each
            field, authority_subtype = field
          end

          add_authority(field, authority, authority_subtype, true)
        end
      end
    end

    def process
      raise 'Data Object has not been created' unless object

      procedures = Lookup.profile_for(profile, type)
      procedures.each do |procedure, attributes|
        next if procedure == 'Authorities'

        object.add_procedure procedure, attributes
        object.save!
      end
      add_related_authorities(procedures.fetch('Authorities', {}))
    end
  end
end
