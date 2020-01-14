module CollectionSpace
  module Converter
    module Core
      class CoreExhibition < Exhibition
        ::CoreExhibition = CollectionSpace::Converter::Core::CoreExhibition
        def convert
          run do |xml|
            CoreExhibition.map(xml, attributes)
          end
        end

        def self.pairs
          {
            'exhibitionnumber' => 'exhibitionNumber',
            'title' => 'title',
            'type' => 'type',
          }
        end

        def self.simple_groups
          {
          }
        end

        def self.simple_repeats
          {
          }
        end

        def self.simple_repeat_lists
          {
          }
        end

        def self.map(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreExhibition.pairs)
=begin
          CSXML::Helpers.add_simple_groups(xml, attributes, CoreExhibition.simple_groups)
          CSXML::Helpers.add_simple_repeats(xml, attributes, CoreExhibition.simple_repeats)
          CSXML::Helpers.add_simple_repeats(xml, attributes, CoreExhibition.simple_repeat_lists, 'List')
=end
          #CSXML.add xml, 'type', CSXML::Helpers.get_vocab('exhibitiontype', attributes['type'])
          overallvenue = {
            'venueorganization' => 'venue',
            'venueopeningdate' => 'venueOpeningDate'
          }
          CSXML.add_group_list(
            xml,
            attributes,
            'venue',
            overallvenue,
            group_suffix: 'Group'
          )
        end
      end
    end
  end
end
