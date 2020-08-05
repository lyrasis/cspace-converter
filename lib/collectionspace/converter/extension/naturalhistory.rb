# frozen_string_literal: true

module CollectionSpace
  module Converter
    module Extension
      module NaturalHistory
        ::NaturalHistory = CollectionSpace::Converter::Extension::NaturalHistory

        def map_natural_history_collectionobject(xml, attributes)
          # taxonomicIdentGroupList, taxonomicIdentGroup
          data = {
            'taxon' => 'taxon',
            'qualifier' => 'qualifier',
            'identbyperson' => 'identBy',
            'identbyorganization' => 'identBy',
            'identdategroup' => 'identDateGroup',
            'institution' => 'institution',
            'identkind' => 'identKind',
            'reference' => 'reference',
            'refpage' => 'refPage',
            'notes' => 'notes'
          }
          transforms = {
            'taxon' => { 'authority' => %w[taxonomyauthority taxon] },
            'qualifier' => { 'vocab' => 'taxonqualifier' },
            'identbyperson' => { 'authority' => %w[personauthorities person] },
            'identbyorganization' => { 'authority' => %w[orgauthorities organization] },
            'identdategroup' => { 'special' => 'structured_date' },
            'institution' => { 'authority' => %w[orgauthorities organization] }, 
            'identkind' => { 'vocab' => 'taxonkind' }
          }

          CSXML.add_single_level_group_list(
            xml, attributes,
            'taxonomicIdent',
            data,
            transforms
          )
        end
      end
    end
  end
end
