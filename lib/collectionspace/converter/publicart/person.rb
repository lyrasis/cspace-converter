module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtPerson < CorePerson
        ::PublicArtPerson = CollectionSpace::Converter::PublicArt::PublicArtPerson
        def redefined_fields
          @redefined.concat([
            'gender',
            'occupation',
            'schoolorstyle',
            'group',
            'nationality',
            'namenote',
            'bionote'
          ])
          super
        end
        
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:persons_common",
                "xmlns:ns2" => "http://collectionspace.org/services/person",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              PublicArtPerson.map_common(xml, attributes, config, redefined_fields)
            end

            xml.send(
              'ns2:persons_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/person/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtPerson.map_publicart(xml, attributes)
              PublicArtPerson.map_social_media(xml, attributes, redefined_fields)
            end

            xml.send(
                "ns2:contacts_common",
                "xmlns:ns2" => "http://collectionspace.org/services/contact",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              Contact.map(xml, attributes)
            end
          end
        end

        def self.map_common(xml, attributes, config, redefined)
          CorePerson.map_common(xml, attributes.merge(redefined), config)
        end
  
        def self.map_publicart(xml, attributes)
          repeats = { 
            'organization' => ['organizations', 'organization']
          }
          repeats_transforms = {
            'organization' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeats_transforms)
        end

        def self.map_social_media(xml, attributes, redefined)
          SocialMedia.map_social_media(xml, attributes.merge(redefined))
        end
        
      end
    end
  end
end
