module CollectionSpace
  module Converter
    module Default
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def config
          @config ||= YAML.safe_load(
            File.open(
              Rails.root.join(
                'lib',
                'collectionspace',
                'converter',
                ENV['CSPACE_CONVERTER_MODULE'].downcase,
                'config.yml'
              )
            )
          )
        end

        def registered_authorities
          config['registered_authorities']
        end

        def registered_procedures
          config['registered_procedures']
        end

        def registered_profiles
          config['registered_profiles']
        end

        def validate_procedure!(procedure, converter)
          valid_procedures = converter.registered_procedures
          unless valid_procedures.include?(procedure)
            raise "Invalid procedure #{procedure}, not permitted by configuration."
          end
        end
      end
    end
  end
end
