module CollectionSpace
  module Converter
    module PublicArt
      COMMON_ERA_URN = "urn:cspace:publicart.collectionspace.org:vocabularies:name(dateera):item:name(ce)'CE'"
      class PublicArtCollectionObject < CollectionObject
        ::PublicArtCollectionObject = CollectionSpace::Converter::PublicArt::PublicArtCollectionObject
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:collectionobjects_common",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              CoreCollectionObject.map(xml, attributes.merge(redefined_fields))
              PublicArtCollectionObject.map_core_overrides(xml, attributes)
            end

            #
            # Public Art extension fields
            #
            xml.send(
              "ns2:collectionobjects_publicart",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/local/publicart",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              PublicArtCollectionObject.map(xml, attributes)
            end

            def redefined_fields
              @redefined = [
                'objectnumber'
              ]
              super
            end

            def self.map_common_overrides(xml, attributes)
              
            end
            
            def self.map(xml, attributes)
              # Example XML payload
              #
              # Column 'objectProductionDate' should map to the <dateDisplayDate> element
              # Column 'objectProductionDateType' should map to the <publicartProductionDateType> element
              #
              # <publicartProductionDateGroupList>
              #     <publicartProductionDateGroup>
              #         <publicartProductionDate>
              #             <dateDisplayDate>7/4/1776</dateDisplayDate>
              #         </publicartProductionDate>
              #         <publicartProductionDateType>
              #             urn:cspace:publicart.collectionspace.org:vocabularies:name(proddatetype):item:name(commission)'commission'
              #         </publicartProductionDateType>
              #     </publicartProductionDateGroup>
              # </publicartProductionDateGroupList>
              #
              proddategroups = []
              proddates = CSDR.split_mvf attributes, 'objectproductiondate'
              proddatetypes = CSDR.split_mvf attributes, 'objectproductiondatetype'
              proddates.each_with_index do |date, index|
                proddategroups << { "publicartProductionDate" => date, "publicartProductionDateType" => proddatetypes[index] }
              end

              xml.send("publicartProductionDateGroupList".to_sym) {
                proddategroups.each do |element|
                  xml.send("publicartProductionDateGroup".to_sym) {
                    if !element["publicartProductionDate"].blank?
                      structured_date = CSDTP::parse element["publicartProductionDate"] if element["publicartProductionDate"]
                      if !structured_date.blank?
                        xml.send("publicartProductionDate".to_sym) {
                          xml.send("scalarValuesComputed".to_sym, "true")
                          xml.send("dateDisplayDate".to_sym, structured_date.display_date)

                          xml.send("dateEarliestSingleDay".to_sym, structured_date.earliest_day)
                          xml.send("dateEarliestSingleMonth".to_sym, structured_date.earliest_month)
                          xml.send("dateEarliestSingleYear".to_sym, structured_date.earliest_year)
                          xml.send("dateEarliestScalarValue".to_sym, structured_date.earliest_scalar)
                          xml.send("dateEarliestSingleEra".to_sym, COMMON_ERA_URN)

                          xml.send("dateLatestDay".to_sym, structured_date.latest_day)
                          xml.send("dateLatestMonth".to_sym, structured_date.latest_month)
                          xml.send("dateLatestYear".to_sym, structured_date.latest_year)
                          xml.send("dateLatestScalarValue".to_sym, structured_date.latest_scalar)
                          xml.send("dateLatestEra".to_sym, COMMON_ERA_URN)
                        }
                      else
                        xml.send("publicartProductionDate".to_sym) {
                          xml.send("dateDisplayDate".to_sym, element["publicartProductionDate"])
                        }
                      end
                    end
                    xml.send("publicartProductionDateType".to_sym, CSURN.get_vocab_urn('proddatetype', element["publicartProductionDateType"]))
                  }
                end
              }

              # Collection
              CSXML.add_repeat xml, 'publicartCollections', [{
                  "publicartCollection" => CSURN.get_authority_urn('orgauthorities', 'organization', attributes["collection"]),
              }] if attributes["collection"]

              # publicartProductionPersonGroupList
              prodpersongroups = []

              prodpersons_urns = []
              prodpersons = CSDR.split_mvf attributes, 'objectproductionperson'
              prodpersons.each do |person, index|
                prodpersons_urns << CSURN.get_authority_urn('personauthorities', 'person', person)
              end

              role_urns = []
              roles = CSDR.split_mvf attributes, 'objectproductionpersonrole'
              roles.each do |role, index|
                role_urns << CSURN.get_vocab_urn('prodpersonrole', role)
              end
              types = CSDR.split_mvf attributes, 'objectproductionpersontype'

              # Build the multi-valued group
              prodpersons_urns.each_with_index do |person_urn, index|
                prodpersongroups << { "publicartProductionPerson" => person_urn, "publicartProductionPersonRole" => role_urns[index], "publicartProductionPersonType" => types[index] }
              end
              CSXML.add_group_list xml, 'publicartProductionPerson', prodpersongroups
            end # def self.map

          end #run(wrapper: "document") do |xml|
        end #def convert
      end # class PublicArtCollectionObject
    end #module PublicArt
  end # module Converter
end # module CollectionSpace
