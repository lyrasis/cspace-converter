module CollectionSpace
  module Converter
    module Materials
      class MaterialsPerson < Person
        ::MaterialsPerson = CollectionSpace::Converter::Materials::MaterialsPerson
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:persons_common",
                "xmlns:ns2" => "http://collectionspace.org/services/person",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              CorePerson.map(xml, attributes, config)
              # MaterialsPerson.map(xml, attributes) # TODO, any different?
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

        def self.map(xml, attributes)
          # TODO
        end
      end
    end
  end
end
