module CollectionSpace
  module Tools
    module Lookup
      ::Lookup = CollectionSpace::Tools::Lookup
      CONVERTER_BASE    = "CollectionSpace::Converter"
      CONVERTER_DEFAULT = "#{CONVERTER_BASE}::Default"
      CONVERTER_MODULE  = ENV.fetch('CSPACE_CONVERTER_MODULE')
      CONVERTER_TOOLS   = "CollectionSpace::Tools"

      # i.e. #{CONVERTER_BASE}::Core::CoreMaterials
      def self.authority_class(authority)
        module_class(authority)
      end

      def self.converter_class
        "#{CONVERTER_BASE}::#{CONVERTER_MODULE}".constantize
      end

      def self.default_authority_class(authority)
        "#{CONVERTER_DEFAULT}::#{authority}".constantize
      end

      def self.default_converter_class
        "#{CONVERTER_DEFAULT}".constantize
      end

      def self.default_relationship_class
        "#{CONVERTER_DEFAULT}::Relationship".constantize
      end

      def self.import_service(type)
        "ImportService::#{type}".constantize
      end

      def self.module_class(type)
        "#{CONVERTER_BASE}::#{CONVERTER_MODULE}::#{CONVERTER_MODULE}#{type}".constantize
      end

      def self.parts_for(category)
        "#{CONVERTER_TOOLS}::Fingerprint::#{category}".constantize
      end

      # i.e. #{CONVERTER_BASE}::PBM::PBMCollectionObject
      def self.procedure_class(procedure)
        module_class(procedure)
      end

      def self.profile_for(profile, type)
        converter_class.registered_profiles[profile][type]
      end

      def self.profile_type(profile)
        converter_class.registered_profiles[profile].keys.first
      end

      def self.service_class
        "#{CONVERTER_TOOLS}::Service".constantize
      end
    end
  end
end
