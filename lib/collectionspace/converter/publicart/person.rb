# frozen_string_literal: true

require_relative '../core/person'

module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtPerson < CorePerson
        ::PublicArtPerson = CollectionSpace::Converter::PublicArt::PublicArtPerson
        include Contact
        include SocialMedia

        def initialize(attributes, config = {})
          super(attributes, config)
          @redefined = [
            'gender',
            'occupation',
            'schoolorstyle',
            'group',
            'nationality',
            'namenote',
            'bionote'
          ]
        end
        
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:persons_common",
                "xmlns:ns2" => "http://collectionspace.org/services/person",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              map_common(xml, attributes.merge(redefined_fields), config)
            end

            xml.send(
              'ns2:persons_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/person/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_publicart(xml, attributes)
              map_social_media(xml, attributes)
            end

            xml.send(
                "ns2:contacts_common",
                "xmlns:ns2" => "http://collectionspace.org/services/contact",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              map_contact(xml, attributes.merge(redefined_fields))
            end
          end
        end

        def map_common(xml, attributes, config)
          # map non-overridden fields according to core logic
          super(xml, attributes, config)
        end
  
        def map_publicart(xml, attributes)
          repeats = { 
            'organization' => ['organizations', 'organization']
          }
          repeats_transforms = {
            'organization' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeats_transforms)
        end
      end
    end
  end
end
