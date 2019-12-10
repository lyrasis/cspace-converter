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
          osteoageestimate = []
          verbatim = CSDR.split_mvf attributes, 'osteoageestimateverbatim'
          age_lower = CSDR.split_mvf attributes, 'osteoageestimatelower'
          age_upper = CSDR.split_mvf attributes, 'osteoageestimateupper'
          age_analyst = CSDR.split_mvf attributes, 'osteoageestimateanalyst'
          age_note = CSDR.split_mvf attributes, 'osteoageestimatenote'

          verbatim.each_with_index do |vbtm, index|
            osteoageestimate << {"osteoAgeEstimateVerbatim" => vbtm, "osteoAgeEstimateLower" => age_lower[index], "osteoAgeEstimateUpper" => age_upper[index], "osteoAgeEstimateAnalyst" =>  CSXML::Helpers.get_authority('personauthorities', 'person', age_analyst[index]), "osteoAgeEstimateNote" => age_note}
          end 
          CSXML.add_group_list xml, 'osteoAgeEstimate', osteoageestimate
          sexdetermination = []
          sex_determination = CSDR.split_mvf attributes, 'sexdetermination'
          determination_analyst = CSDR.split_mvf attributes, 'sexdeterminationanalyst'
          determination_note = CSDR.split_mvf attributes, 'sexdeterminationnote'
          sex_determination.each_with_index do |sxd, index|
            sexdetermination << {"sexDetermination" => sxd, "sexDeterminationAnalyst" => CSXML::Helpers.get_authority('personauthorities', 'person', determination_analyst[index]), "sexDeterminationNote" => determination_note[index]}
          end 
          CSXML.add_group_list xml, 'sexDetermination', sexdetermination
        end
      end
    end
  end
end
