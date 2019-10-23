module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtOrganization < Organization
        ::PublicArtOrganization = CollectionSpace::Converter::PublicArt::PublicArtOrganization
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:organizations_common",
                "xmlns:ns2" => "http://collectionspace.org/services/organization",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil

              # TODO: CoreOrganization
              CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["termdisplayname"])

              CSXML.add_group_list xml, 'orgTerm',
                                   [{
                                        "termDisplayName" => attributes["termdisplayname"],
                                        "mainBodyName" => attributes["mainbodyname"],
                                    }]
            end

            xml.send(
                "ns2:organizations_publicart",
                "xmlns:ns2" => "http://collectionspace.org/services/organization/local/publicart",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              PublicArtOrganization.extension(xml, attributes)
            end

            xml.send(
                "ns2:contacts_common",
                "xmlns:ns2" => "http://collectionspace.org/services/contact",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              PublicArtOrganization.contact(xml, attributes)
            end
          end
        end

        def self.contact(xml, attributes)
          # webaddress
          CSXML.add_group_list xml, 'webAddress',
                                [{
                                    "webAddress" => attributes["webaddress"],
                                    "webAddressType" => attributes["webaddresstype"],
                                }]
        end

        def self.extension(xml, attributes)
          CSXML.add xml, 'currentPlace', CSURN.get_authority_urn('placeauthorities', 'place', attributes["currentPlace"])
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
