module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtConservation < Conservation
        ::PublicArtConservation = CollectionSpace::Converter::PublicArt::PublicArtConservation
        def redefined_fields
          @redefined.concat([
            # not in publicart
            'destanalysisapproveddate',
            'destanalysisapprovalnote',
            'sampleby',
            'sampledate',
            'sampledescription',
            'samplereturned',
            'samplereturnedlocation',
            # overridden by publicart
            'conservator',
            'otherparty',
            'examinationstaff',
            'approvedby',
            'researcher' 
          ])
          super
        end
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:conservation_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/conservation',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtConservation.map_common(xml, attributes, redefined_fields)
            end

            xml.send(
              'ns2:conservation_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/conservation/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtConservation.map_publicart(xml, attributes)
            end
          end
        end

        def self.map_common(xml, attributes, redefined)
          CoreConservation.map_common(xml, attributes.merge(redefined))
          pairs = {
            'approvedbylocal' => 'approvedBy',
            'approvedbyshared' => 'approvedBy',
            'researcherlocal' => 'researcher',
            'researchershared' => 'researcher'
          }
          pairstransforms = {
            'approvedbylocal' => {'authority' => ['personauthorities', 'person']},
            'approvedbyshared' => {'authority' => ['personauthorities', 'person_shared']},
            'researcherlocal' => {'authority' => ['personauthorities', 'person']},
            'researchershared' => {'authority' => ['personauthorities', 'person_shared']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)
          repeats = {
            'conservatorpersonlocal' => ['conservators', 'conservator'],
            'conservatorpersonshared' => ['conservators', 'conservator'],
            'conservatororganizationlocal' => ['conservators', 'conservator'],
            'conservatororganizationshared' => ['conservators', 'conservator']
          }
          repeatstransforms = {
            'conservatorpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'conservatorpersonshared' => {'authority' => ['personauthorities', 'person_shared']},
            'conservatororganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'conservatororganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          #otherPartyGroupList, otherPartyGroup
          other_party = {
            'otherpartypersonlocal' => 'otherParty',
            'otherpartypersonshared' => 'otherParty',
            'otherpartyorganizationlocal' => 'otherParty',
            'otherpartyorganizationshared' => 'otherParty',
            'otherpartyrole' => 'otherPartyRole',
            'otherpartynote' => 'otherPartyNote'
          }
          other_partytransforms = {
            'otherpartypersonlocal' => {'authority' => ['personauthorities', 'person']},
            'otherpartypersonshared' => {'authority' => ['personauthorities', 'person_shared']},
            'otherpartyorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'otherpartyorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']},
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
            'examinationstafflocal' => 'examinationStaff',
            'examinationstaffshared' => 'examinationStaff',
            'examinationphase' => 'examinationPhase',
            'examinationdate' => 'examinationDate',
            'examinationnote' => 'examinationNote'
          }
          examinationtransforms = {
            'examinationstafflocal' => {'authority' => ['personauthorities', 'person']},
            'examinationstaffshared' => {'authority' => ['personauthorities', 'person_shared']},
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
   
        def self.map_publicart(xml, attributes)
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
