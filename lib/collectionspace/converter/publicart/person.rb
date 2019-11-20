module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtPerson < Person
        ::PublicArtPerson = CollectionSpace::Converter::PublicArt::PublicArtPerson
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:persons_common",
                "xmlns:ns2" => "http://collectionspace.org/services/person",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              CorePerson.map(xml, attributes)
            end

            xml.send(
                "ns2:persons_publicart",
                "xmlns:ns2" => "http://collectionspace.org/services/person/local/publicart",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              PublicArtPerson.extension(xml, attributes)
            end

            xml.send(
                "ns2:contacts_common",
                "xmlns:ns2" => "http://collectionspace.org/services/contact",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              Contact.map(xml, attributes)
            end
          end
        end

        def self.extension(xml, attributes)
          organization_urns = []
          organizations = split_mvf attributes, 'organization'
          organizations.each do |organization|
            organization_urns << { "organization" => CSURN.get_authority_urn('orgauthorities', 'organization', organization, true) }
          end
          CSXML.add_repeat(xml, 'organizations', organization_urns)
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
