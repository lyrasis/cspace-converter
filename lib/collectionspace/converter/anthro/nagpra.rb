module CollectionSpace
  module Converter
    module Anthro
      class AnthroNagpra < Nagpra
        ::AnthroNagpra = CollectionSpace::Converter::Anthro::AnthroNagpra
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:claims_common",
                "xmlns:ns2" => "http://collectionspace.org/services/claim",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              AnthroNagpra.map(xml, attributes)
            end

            xml.send(
                "ns2:claims_nagpra",
                "xmlns:ns2" => "http://collectionspace.org/services/claim/domain/nagpra",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              AnthroNagpra.extension(xml, attributes)
            end
          end
        end

        def self.extension(xml, attributes)
          # TODO: implement mapping for claims_nagpra
        end

        def self.map(xml, attributes)
          # TODO: implement mapping for claims_common
        end
      end
    end
  end
end
