module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtConservation < Conservation
        ::PublicArtConservation = CollectionSpace::Converter::PublicArt::PublicArtConservation
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:conservation_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/conservation',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtConservation.map(xml, attributes)
            end

            xml.send(
              'ns2:conservation_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/conservation/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtConservation.extension(xml, attributes)
            end
          end
        end

        def self.map(xml, attributes)
          pairs = {
            'conservationnumber' => 'conservationNumber',
            'treatmentpurpose' => 'treatmentPurpose',
            'fabricationnote' => 'fabricationNote',
            'proposedtreatment' => 'proposedTreatment',
            'approvedby' => 'approvedBy',
            'approveddate' => 'approvedDate',
            'treatmentstartdate' => 'treatmentStartDate',
            'treatmentenddate' => 'treatmentEndDate',
            'treatmentsummary' => 'treatmentSummary',
            'proposedanalysis' => 'proposedAnalysis',
            'researcher' => 'researcher',
            'proposedanalysisdate' => 'proposedAnalysisDate',
            'analysismethod' => 'analysisMethod',
            'analysisresults' => 'analysisResults'
          }
          pairstransforms = {
            'treatmentpurpose' => {'vocab' => 'treatmentpurpose'},
            'approvedby' => {'authority' => ['personauthorities', 'person']},
            'approveddate' => {'special' => 'unstructured_date_stamp'},
            'treatmentstartdate' => {'special' => 'unstructured_date_stamp'},
            'treatmentenddate' => {'special' => 'unstructured_date_stamp'},
            'researcher' => {'authority' => ['personauthorities', 'person']},
            'proposedanalysisdate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)

          repeats = {
            'conservatorperson' => ['conservators', 'conservator'],
            'conservatororganization' => ['conservators', 'conservator']
          }
          repeatstransforms = {
            'conservatorperson' => {'authority' => ['personauthorities', 'person']},
            'conservatororganization' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          #conservationStatusGroupList, conservationStatusGroup
          conservation_status = {
            'status' => 'status',
            'statusdate' => 'statusDate'
          }
          conservation_statustransforms = {
            'status' => {'vocab' => 'conservationstatus'},
            'statusdate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'conservationStatus',
            conservation_status,
            conservation_statustransforms
          )
          #otherPartyGroupList, otherPartyGroup
          other_party = { 
            'otherpartyperson' => 'otherParty',
            'otherpartyorganization' => 'otherParty',
            'otherpartyrole' => 'otherPartyRole',
            'otherpartynote' => 'otherPartyNote'
          }
          other_partytransforms = {
            'otherpartyperson' => {'authority' => ['personauthorities', 'person']},
            'otherpartyorganization' => {'authority' => ['orgauthorities', 'organization']},
            'otherpartyrole' => {'vocab' => 'otherpartyrole'}
          }
          CSXML.add_single_level_group_list( 
            xml,
            attributes,
            'otherParty',
            other_party,
            other_partytransforms
          )
          #examinationGroupList, examinationGroup
          overall_examination = {        
            'examinationstaff' => 'examinationStaff',
            'examinationphase' => 'examinationPhase',
            'examinationdate' => 'examinationDate',
            'examinationnote' => 'examinationNote'
          }
          examinationtransforms = {
            'examinationstaff' => {'authority' => ['personauthorities', 'person']},
            'examinationdate' => {'special' => 'unstructured_date_stamp'},
            'examinationphase' => {'vocab' => 'examinationphase'}
          }
          CSXML.add_single_level_group_list( 
            xml,
            attributes,
            'examination',
            overall_examination,
            examinationtransforms
          )
        end
   
        def self.extension(xml, attributes)
          pairs = {
            'treatmentstartdate' => 'proposedTreatmentStartDate',
            'treatmentenddate' => 'proposedTreatmentEndDate',
            'proposedtreatmentestcurrency' => 'proposedTreatmentEstCurrency',
            'proposedtreatmentestvalue' => 'proposedTreatmentEstValue',
            'treatmentcostcurrency' => 'treatmentCostCurrency',
            'treatmentcostvalue' => 'treatmentCostValue',
            'conservationprioritylevel' => 'conservationPriorityLevel',
            'analysisrecommendations' => 'analysisRecommendations',
            'proposedtreatmentcontractrestrictions' => 'proposedTreatmentContractRestrictions',
          }
          pairs_transforms = {
            'treatmentstartdate' => {'special' => 'unstructured_date_stamp'},
            'treatmentenddate' => {'special' => 'unstructured_date_stamp'},
            'proposedtreatmentestcurrency' => {'vocab' => 'currency'},
            'treatmentcostcurrency' => {'vocab' => 'currency'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
        end
      end
    end
  end
end
