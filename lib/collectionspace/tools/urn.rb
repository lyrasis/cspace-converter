module CollectionSpace
  module Tools
    module URN
      ::CSURN = CollectionSpace::Tools::URN
      def self.generate(domain, type, sub, identifier, label)
        "urn:cspace:#{domain}:#{type}:name(#{sub}):item:name(#{identifier})'#{label}'"
      end

      def self.get_authority_urn(authority, authority_subtype, display_name)
        id = AuthCache.authority(authority, authority_subtype, display_name)
        id ||= CSIDF.short_identifier(display_name)
        generate(
          Rails.application.config.domain,
          authority,
          authority_subtype,
          id,
          display_name
        )
      end

      def self.get_vocab_urn(vocabulary, display_name)
        identifier = AuthCache.vocabulary(vocabulary, display_name)
        identifier ||= display_name.to_s.downcase
        generate(
          Rails.application.config.domain,
          'vocabularies',
          vocabulary,
          identifier,
          display_name
        )
      end

      def self.parse(refname)
        parts = refname.split(':')
        {
          domain: parts[2],
          type: parts[3],
          subtype: parts[4].match(/\((.*)\)/).captures[0],
          identifier: parts[6].match(/\((.*)\)/).captures[0],
          label: parts[6].match(/'(.*)'/).captures[0]
        }
      end

      def self.parse_subtype(refname)
        refname.split(':')[4].match(/\((.*)\)/).captures[0]
      end

      def self.parse_type(refname)
        refname.split(':')[3]
      end
    end
  end
end
