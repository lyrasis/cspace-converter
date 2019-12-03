# frozen_string_literal: true

module CollectionSpace
  module Converter
    module Anthro
      class AnthroOsteology < Osteology
        ::AnthroOsteology = CollectionSpace::Converter::Anthro::AnthroOsteology
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:osteology_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/osteology',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              AnthroOsteology.map(xml, attributes)
            end

            xml.send(
              'ns2:osteology_anthropology',
              'xmlns:ns2' => 'http://collectionspace.org/services/osteology/domain/anthropology',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              AnthroOsteology.extension(xml, attributes)
            end
          end
        end

        def self.extension(xml, attributes)
          # TODO
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'InventoryID', attributes['inventoryid']
        end
      end
    end
  end
end
