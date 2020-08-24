# frozen_string_literal: true

require_relative '../core/conditioncheck'

module CollectionSpace
  module Converter
    module Lhmc
      class LhmcConditionCheck < CoreConditionCheck
        ::LhmcConditionCheck = CollectionSpace::Converter::Lhmc::LhmcConditionCheck

        def initialize(attributes, config = {})
          super(attributes, config)
          @redefined = [
            'condition',
            'conditiondate',
            'conditionnote'
          ]
        end

        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:conditionchecks_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/conditioncheck',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_common(xml, attributes)
            end

            xml.send(
              'ns2:conditionchecks_lhmc',
              'xmlns:ns2' => 'http://collectionspace.org/services/conditioncheck/domain/lhmc',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_lhmc(xml, attributes)
            end
          end
        end

        def map_common(xml, attributes)
          super(xml, attributes.merge(redefined_fields))
        end

        def map_lhmc(xml, attributes)
          cond = {
            'conditionlhmc' => 'conditionLHMC',
            'conditionfacetlhmc' => 'conditionFacetLHMC',
            'conditiondatelhmc' => 'conditionDateLHMC',
            'conditionnotelhmc' => 'conditionNoteLHMC'
          }
          cond_transforms = {
            'conditionlhmc' => {'vocab' => 'condition'},
            'conditionfacetlhmc' => {'vocab' => 'conditionfacet'},
            'conditiondatelhmc' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'conditionCheckLHMC',
            cond,
            cond_transforms
          )
        end
      end
    end
  end
end
