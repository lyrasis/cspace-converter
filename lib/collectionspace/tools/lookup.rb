module CollectionSpace
  module Tools
    module Lookup
      ::Lookup = CollectionSpace::Tools::Lookup
      CONVERTER_BASE    = "CollectionSpace::Converter"
      CONVERTER_DEFAULT = "#{CONVERTER_BASE}::Default"
      CONVERTER_TOOLS   = "CollectionSpace::Tools"

      def self.async?
        ENV.fetch('CSPACE_CONVERTER_ASYNC_JOBS', 'true') == 'true'
      end

      # i.e. #{CONVERTER_BASE}::Core::CoreMaterials
      def self.authority_class(authority)
        module_class(authority)
      end

      def self.converter_class
        "#{CONVERTER_BASE}::#{converter_module}".constantize
      end

      def self.converter_domain
        ENV.fetch('CSPACE_CONVERTER_DOMAIN')
      end

      def self.converter_module
        ENV.fetch('CSPACE_CONVERTER_MODULE')
      end

      def self.default_authority_class(authority)
        "#{CONVERTER_DEFAULT}::#{authority}".constantize
      end

      def self.default_converter_class
        "#{CONVERTER_DEFAULT}".constantize
      end

      def self.default_hierarchy_class
        "#{CONVERTER_DEFAULT}::Hierarchy".constantize
      end

      def self.default_relationship_class
        "#{CONVERTER_DEFAULT}::Relationship".constantize
      end

      def self.default_vocabulary_class
        "#{CONVERTER_DEFAULT}::Vocabulary".constantize
      end

      def self.import_service(type)
        "ImportService::#{type}".constantize
      end

      def self.module_class(type)
        "#{CONVERTER_BASE}::#{converter_module}::#{converter_module}#{type}".constantize
      end

      def self.parts_for(category)
        "#{CONVERTER_TOOLS}::Fingerprint::#{category}".constantize
      end

      # i.e. #{CONVERTER_BASE}::PBM::PBMCollectionObject
      def self.procedure_class(procedure)
        module_class(procedure)
      end

      def self.profile_config(profile)
        converter_class.registered_profiles[profile]['config']
      end

      def self.profile_defaults(profile)
        converter_class.registered_profiles[profile].fetch('defaults', {})
      end

      def self.profile_headers(profile)
        converter_class.registered_profiles[profile].fetch('required_headers', []).map(&:to_sym)
      end

      def self.profile_type(profile)
        converter_class.registered_profiles[profile]['type']
      end

      def self.record_class(type)
        "#{CONVERTER_DEFAULT}::#{type}".constantize
      end

      def self.service_class
        "#{CONVERTER_TOOLS}::Service".constantize
      end
    end
  end
end
