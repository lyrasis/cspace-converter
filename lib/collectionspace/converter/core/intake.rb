module CollectionSpace
  module Converter
    module Core
      class CoreIntake < Intake
        ::CoreIntake = CollectionSpace::Converter::Core::CoreIntake
        def convert
          run do |xml|
            CoreIntake.map(xml, attributes)
          end
        end

        def self.pairs
          {
            'entrynumber' => 'entryNumber',
            'depositorsrequirements' => 'depositorsRequirements',
            'entrydate' => 'entryDate',
            'entrynote' => 'entryNote',
            'entryreason' => 'entryReason',
            'packingnote' => 'packingNote',
            'returndate' => 'returnDate',
            'fieldcollectiondate' => 'fieldCollectionDate',
            'fieldcollectionnote' => 'fieldCollectionNote',
            'fieldcollectionnumber' => 'fieldCollectionNumber',
            'fieldcollectionplace' => 'fieldCollectionPlace',
            'valuationreferencenumber' => 'valuationReferenceNumber',
            'insurancenote' => 'insuranceNote',
            'insurancepolicynumber' => 'insurancePolicyNumber',
            'insurancereferencenumber' => 'insuranceReferenceNumber',
            'insurancerenewaldate' => 'insuranceRenewalDate',
            'locationdate' => 'locationDate',
            
            
            
            
          }
        end

        def self.map(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreIntake.pairs,
          pairstransforms = {
            'entrydate' => {'special' => 'unstructured_date_stamp'},
            'returndate' => {'special' => 'unstructured_date_stamp'},
            'insurancerenewaldate' => {'special' => 'unstructured_date_stamp'},
            'locationdate' => {'special' => 'unstructured_date_stamp'},

          }) rescue nil
          #CSXML::Helpers.add_simple_repeats(xml, attributes, CoreIntake.simple_repeats)
          CSXML.add xml, 'currentOwner', CSXML::Helpers.get_authority('personauthorities', 'person', attributes["currentownerperson"]) if attributes["currentownerperson"]
          CSXML.add xml, 'currentOwner', CSXML::Helpers.get_authority('orgauthorities', 'organization', attributes["currentownerorganization"]) if attributes["currentownerorganization"]
          CSXML.add xml, 'depositor', CSXML::Helpers.get_authority('personauthorities', 'person', attributes["depositorperson"]) if attributes["depositorperson"]
          CSXML.add xml, 'depositor', CSXML::Helpers.get_authority('orgauthorities', 'organization', attributes["depositororganization"]) if attributes["depositororganization"]
          CSXML.add_repeat xml, 'entryMethods', [ { 'entryMethod' => CSXML::Helpers.get_vocab('entrymethod', attributes["entrymethod"]) }]
          CSXML.add_repeat xml, 'fieldCollectionMethods', [{ 'fieldCollectionMethod' => CSXML::Helpers.get_vocab('collectionmethod', attributes["fieldcollectionmethod"]) }]
          CSXML.add_repeat xml, 'fieldCollectionSources', [{ 'fieldCollectionSource' => CSXML::Helpers.get_authority('personauthorities', 'person', attributes["fieldcollectionsourceperson"])}] if attributes["fieldcollectionsourceperson"]
          fieldcollect = []
          fieldcollectorperson = CSDR.split_mvf attributes, 'fieldcollectorsperson'
          fieldcollectororg = CSDR.split_mvf attributes, 'fieldcollectorsorganization'
          fieldcollectorperson.each_with_index do |fcp, index|
            fieldcollect << {"fieldCollector" =>  CSXML::Helpers.get_authority('personauthorities', 'person', fcp)}
            fieldcollect <<  {"fieldCollector" =>  CSXML::Helpers.get_authority('orgauthorities', 'organization', fieldcollectororg[index])}
          end
          CSXML.add_repeat xml, 'fieldCollectors', fieldcollect

=begin
          overall_fieldcollectors = {
            'fieldcollectorsorganization' => 'fieldCollector',
            'fieldcollectorsperson' => 'fieldCollector'
          }

          fieldcollectorstransforms = {
            'fieldcollectorsorganization' => {'authority' => ['orgauthorities', 'organization']},
            'fieldcollectorsperson' => {'authority' => ['personauthorities', 'person']}
          }

          CSXML::Helpers.add_repeats(
            xml,
            attributes,
            overall_fieldcollectors,
            fieldcollectorstransforms
          )
=end
          fceventname = []
          eventname = CSDR.split_mvf attributes, 'fieldcollectioneventname'
          eventname.each_with_index do |fcen, index|
            fceventname << {"fieldCollectionEventName" =>  fcen}
          end
          CSXML.add_repeat xml, 'fieldCollectionEventNames', fceventname
          CSXML.add xml, 'valuer', CSXML::Helpers.get_authority('personauthorities', 'person', attributes["valuerperson"]) if attributes["valuerperson"]
          CSXML.add xml, 'valuer', CSXML::Helpers.get_authority('orgauthorities', 'organization', attributes["valuerorganization"]) if attributes["valuerorganization"]
          insurers = []
          insurerperson = CSDR.split_mvf attributes, 'insurerperson'
          insurerorg = CSDR.split_mvf attributes, 'insurerorganization'
          insurerorg.each_with_index do |io, index|
            insurers << {"insurer" =>  CSXML::Helpers.get_authority('orgauthorities', 'organization', io)}
            insurers <<  {"insurer" =>  CSXML::Helpers.get_authority('personauthorities', 'person', insurerperson[index])}
          end
          CSXML.add_repeat xml, 'insurers', insurers
          current_location = {
            'currentlocationnote' => 'currentLocationNote',
            'currentlocationfitness' => 'currentLocationFitness',
            'currentlocationstorage' => 'currentLocation',
            'currentlocationplace' => 'currentLocation'
          }

          currentlocationtransforms = {
            'currentlocationfitness' => {'vocab' => 'conditionfitness'},
            'currentlocationstorage' => {'authority' => ['locationauthorities', 'location']},
            'currentlocationplace' => {'authority' => ['placeauthorities', 'place']}
          }

          CSXML.prep_and_add_single_level_group_list(
            xml,
            attributes,
            'currentLocation',
            current_location,
            currentlocationtransforms
          )
          CSXML.add xml, 'normalLocation', CSXML::Helpers.get_authority('locationauthorities', 'location', attributes["normallocationstorage"]) if attributes["normallocationstorage"]
          CSXML.add xml, 'normalLocation', CSXML::Helpers.get_authority('placeauthorities', 'place', attributes["normalLocationplace"]) if attributes["normalLocationplace"]

 

        end
      end
    end
  end
end
