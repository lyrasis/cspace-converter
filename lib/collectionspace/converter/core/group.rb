module CollectionSpace
  module Converter
    module Core
      class CoreGroup < Group
        ::CoreGroup = CollectionSpace::Converter::Core::CoreGroup
        def convert
          run do |xml|
            CoreGroup.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          pairs = {
            'title' => 'title',
            'owner' => 'owner',
            'scopenote' => 'scopeNote',
            'responsibledepartment' => 'responsibleDepartment',
            'grouplatestdate' => 'groupLatestDate',
            'groupearliestsingledate' => 'groupEarliestSingleDate'
          }
          pairstransforms = {
            'grouplatestdate' => {'special' => 'unstructured_date_stamp'},
            'groupearliestsingledate' => {'special' => 'unstructured_date_stamp'},
            'owner' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
        end
      end
    end
  end
end
