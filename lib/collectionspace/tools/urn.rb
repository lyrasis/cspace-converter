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
          Lookup.converter_domain,
          authority,
          authority_subtype,
          id,
          display_name
        )
      end

      def self.get_vocab_urn(vocabulary, display_name)
        identifier = AuthCache.vocabulary(vocabulary, display_name)
        if identifier.nil?
          identifier ||= AuthCache.vocabulary(vocabulary, display_name.downcase)
          display_name = display_name.downcase unless identifier.nil?
        end
        identifier ||= display_name.to_s.gsub(/\W/, '').downcase
        generate(
          Lookup.converter_domain,
          'vocabularies',
          vocabulary,
          identifier,
          display_name
        )
      end

      def self.parse(refname)
        parts = refname.split(':')
        parts[6] = parts[6..parts.length].join(':') if parts.length > 7
        {
          domain: parts[2],
          type: parts[3],
          subtype: parts[4].match(/\((.*)\)/).captures[0],
          identifier: parts[6].match(/\((.*?)\)/).captures[0],
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
