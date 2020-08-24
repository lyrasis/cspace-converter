# frozen_string_literal: true

require_relative '../core/conditioncheck'

module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtConditionCheck < CoreConditionCheck
        ::PublicArtConditionCheck = CollectionSpace::Converter::PublicArt::PublicArtConditionCheck
        def initialize(attributes, config = {})
          super(attributes, config)
          @redefined = [
            'hazard',
            'hazarddate',
            'hazardnote',
            'securityrecommendations',
            'storagerequirements',
            'packingrecommendations',
            'legalreqsheldnumber',
            'salvageprioritycode',
            'salvageprioritycodedate',
            # overridden by publicart
            'conditionchecker'
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
              'ns2:conditionchecks_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/conditioncheck/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              map_publicart(xml, attributes)
            end
          end
        end

        def map_common(xml, attributes)
          super(xml, attributes.merge(redefined_fields))
          pairs = {
            'conditioncheckerlocalperson' => 'conditionChecker',
            'conditioncheckerlocalorganization' => 'conditionChecker',
            'conditioncheckersharedperson' => 'conditionChecker',
            'conditioncheckersharedorganization' => 'conditionChecker'
          }
          pairstransforms = {
            'conditioncheckerlocalperson' => {'authority' => ['personauthorities', 'person']},
            'conditioncheckersharedperson' => {'authority' => ['personauthorities', 'person_shared']},
            'conditioncheckerlocalorganization' => {'authority' => ['orgauthorities', 'organization']},
            'conditioncheckersharedorganization' => {'authority' => ['orgauthorities', 'organization_shared']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
        end
  
        def map_publicart(xml, attributes)
          pairs = {
            'installationrecommendations' => 'installationRecommendations'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
        end

      end
    end
  end
end
