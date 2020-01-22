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

        def self.map(xml, attributes)
          pairs = {
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
              'conditioncheckdate' => 'conditionCheckDate',
              'conditionchecknote' => 'conditionCheckNote',
              'conditioncheckreferencenumber' => 'conditionCheckReferenceNumber',
              'currentownerperson' => 'currentOwner',
              'currentownerorganization' => 'currentOwner',
              'depositorperson' => 'depositor',
              'depositororganization' => 'depositor',
              'valuerperson' => 'valuer',
              'valuerorganization' => 'valuer',
              'insurerperson' => 'insurer',
              'insurerorganization' => 'insurer',
              'normallocationstorage' => 'normalLocation',
              'normallocationplace' => 'normalLocation',
              'normallocationorganization' => 'normalLocation'
            }
          pairstransforms = {
            'entrydate' => {'special' => 'unstructured_date_stamp'},
            'returndate' => {'special' => 'unstructured_date_stamp'},
            'insurancerenewaldate' => {'special' => 'unstructured_date_stamp'},
            'locationdate' => {'special' => 'unstructured_date_stamp'},
            'fieldcollectiondate' => {'special' => 'unstructured_date_stamp'},
            'conditioncheckdate' => {'special' => 'unstructured_date_stamp'},
            'currentownerperson' => {'authority' => ['personauthorities', 'person']},
            'currentownerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'depositorperson' => {'authority' => ['personauthorities', 'person']},
            'depositororganization' => {'authority' => ['orgauthorities', 'organization']},
            'valuerperson' => {'authority' => ['personauthorities', 'person']},
            'valuerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'insurerperson' => {'authority' => ['personauthorities', 'person']},
            'insurerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'normallocationstorage' => {'authority' => ['locationauthorities', 'location']},
            'normallocationplace' => {'authority' => ['placeauthorities', 'place']},
            'normallocationorganization' => {'authority' => ['orgauthorities', 'organization']},
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)

          repeats = { 
            'entrymethod' => ['entryMethods', 'entryMethod'],
            'fieldcollectionmethod' => ['fieldCollectionMethods', 'fieldCollectionMethod'],
            'fieldcollectioneventname' => ['fieldCollectionEventNames', 'fieldCollectionEventName'],
            'conditioncheckmethod' => ['conditionCheckMethods', 'conditionCheckMethod'],
            'conditioncheckreason' => ['conditionCheckReasons', 'conditionCheckReason'],
            'fieldcollectororganization' => ['fieldCollectors', 'fieldCollector'],
            'fieldcollectorperson' => ['fieldCollectors', 'fieldCollector'],
            'fieldcollectionsource' => ['fieldCollectionSources', 'fieldCollectionSource'],
            'conditioncheckerorassessororganization' => ['conditionCheckersOrAssessors', 'conditionCheckerOrAssessor'],
            'conditioncheckerorassessorperson' => ['conditionCheckersOrAssessors', 'conditionCheckerOrAssessor']
          }
          repeatstransforms = {
            'entrymethod' => {'vocab' => 'entrymethod'},
            'fieldcollectionmethod' => {'vocab' => 'collectionmethod'},
            'conditioncheckmethod' => {'vocab' => 'conditioncheckmethod'},
            'conditioncheckreason' => {'vocab' => 'conditioncheckreason'},
            'fieldcollectorperson' => {'authority' => ['personauthorities', 'person']}, 
            'fieldcollectororganization' => {'authority' => ['orgauthorities', 'organization']},
            'fieldcollectionsource' => {'authority' => ['personauthorities', 'person']},
            'conditioncheckerorassessororganization' => {'authority' => ['orgauthorities', 'organization']},
            'conditioncheckerorassessorperson' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)


          current_location = {
            'currentlocationnote' => 'currentLocationNote',
            'currentlocationfitness' => 'currentLocationFitness',
            'currentlocationstorage' => 'currentLocation',
            'currentlocationplace' => 'currentLocation',
            'currentlocationorganization' => 'currentLocation'          }

          currentlocationtransforms = {
            'currentlocationfitness' => {'vocab' => 'conditionfitness'},
            'currentlocationstorage' => {'authority' => ['locationauthorities', 'location']},
            'currentlocationplace' => {'authority' => ['placeauthorities', 'place']},
            'currentlocationorganization' => {'authority' => ['orgauthorities', 'organization']}
          }

          CSXML.prep_and_add_single_level_group_list(
            xml,
            attributes,
            'currentLocation',
            current_location,
            currentlocationtransforms
          )
        end
      end
    end
  end
end
