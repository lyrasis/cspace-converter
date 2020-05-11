module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtOrganization < Organization
        ::PublicArtOrganization = CollectionSpace::Converter::PublicArt::PublicArtOrganization
        def redefined_fields
          @redefined.concat([
            # not in publicart
            'contactname',
            'group',
            'function',
            # overridden by publicart
            'foundingplace'
          ])
          super
        end

        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:organizations_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/organization',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtOrganization.map_common(xml, attributes, config, redefined_fields)
            end

            xml.send(
                "ns2:contacts_common",
                "xmlns:ns2" => "http://collectionspace.org/services/contact",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              Contact.map(xml, attributes)
            end

            xml.send(
              'ns2:organizations_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/organization/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtOrganization.map_publicart(xml, attributes)
              PublicArtOrganization.map_social_media(xml, attributes, redefined_fields)
            end
          end
        end


        def self.map_publicart(xml, attributes)
          pairs = {
            'currentplace' => 'currentPlace',
            'placementtype' => 'placementType'
          }
          pairs_transforms = {
            'currentplace' => {'authority' => ['placeauthorities', 'place']},
            'placementtype' => {'vocabulary' => 'placementtypes'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
        end

        def self.map_social_media(xml, attributes, redefined)
          SocialMedia.map_social_media(xml, attributes.merge(redefined))
        end

        def self.map_common(xml, attributes, config, redefined)
          CoreOrganization.map_common(xml, attributes.merge(redefined), config)
          
          pairs = {
            'foundingplacelocal' => 'foundingPlace',
            'foundingplaceshared' => 'foundingPlace'            
          }
          pairs_transforms = {
            'foundingplacelocal' => {'authority' => ['placeauthorities', 'place']},
            'foundingplaceshared' => {'authority' => ['placeauthorities', 'place_shared']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
        end
      end
    end
  end
end
