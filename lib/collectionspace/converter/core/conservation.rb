module CollectionSpace
  module Converter
    module Core
      class CoreConservation < Conservation
        ::CoreConservation = CollectionSpace::Converter::Core::CoreConservation
        def convert
          run do |xml|
            CoreConservation.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'conservationNumber', attributes["conservationnumber"]
          conservation_status = []
          status = CSDR.split_mvf attributes, 'status'
          statusdate = CSDR.split_mvf attributes, 'statusdate'
          status.each_with_index do |stat, index|
            conservation_status << {"status" => CSXML::Helpers.get_vocab('conservationstatus', stat), "statusDate" => CSDTP.parse(statusdate[index]).earliest_scalar}
          end
          CSXML.add_group_list xml, 'conservationStatus', conservation_status
          CSXML.add xml, 'treatmentPurpose', CSXML::Helpers.get_vocab('treatmentpurpose', attributes["treatmentpurpose"])
          overall_conservator = []
          conservator = CSDR.split_mvf attributes, 'conservator'
          conservator.each_with_index do |cnsv, index|
            overall_conservator << {"conservator" => CSXML::Helpers.get_authority('personauthorities', 'person', cnsv)}
          end
          CSXML.add_repeat xml, 'conservators', overall_conservator
          other_party = []
          oparty = CSDR.split_mvf attributes, 'otherparty'
          orole = CSDR.split_mvf attributes, 'otherpartyrole'
          onote = CSDR.split_mvf attributes, 'otherpartynote'
          oparty.each_with_index do |otp, index|
            other_party << {"otherParty" => CSXML::Helpers.get_authority('personauthorities', 'person', otp), "otherPartyRole" => CSXML::Helpers.get_vocab('otherpartyrole', orole[index]), "otherPartyNote" => onote[index]}
          end
          CSXML.add_group_list xml, 'otherParty', other_party
          overall_examination = []
          examstaff = CSDR.split_mvf attributes, 'examinationstaff'
          examphase = CSDR.split_mvf attributes, 'examinationphase'
          examdate = CSDR.split_mvf attributes, 'examinationdate'
          examnote = CSDR.split_mvf attributes, 'examinationnote'
          examstaff.each_with_index do |exst, index|
            overall_examination << {"examinationStaff" => CSXML::Helpers.get_authority('personauthorities', 'person', exst), "examinationDate" => CSDTP.parse(examdate[index]).earliest_scalar, "examinationPhase" => CSXML::Helpers.get_vocab('examinationphase', examphase[index]), "examinationNote" => examnote[index]}
          end
          CSXML.add_group_list xml, 'examination', overall_examination
          CSXML.add xml, 'fabricationNote', attributes["fabricationnote"]
          CSXML.add xml, 'proposedTreatment', attributes["proposedtreatment"]
          CSXML.add xml, 'approvedBy', CSXML::Helpers.get_authority('personauthorities', 'person', attributes["approvedby"])
          CSXML.add xml, 'approvedDate', CSDTP.parse(attributes["approveddate"]).earliest_scalar
          CSXML.add xml, 'treatmentStartDate', CSDTP.parse(attributes["treatmentstartdate"]).earliest_scalar
          CSXML.add xml, 'treatmentEndDate', CSDTP.parse(attributes["treatmentenddate"]).earliest_scalar
          CSXML.add xml, 'treatmentSummary', attributes["treatmentsummary"]
          CSXML.add xml, 'proposedAnalysis', attributes["proposedanalysis"]
          CSXML.add xml, 'researcher', CSXML::Helpers.get_authority('personauthorities', 'person', attributes["researcher"])
          CSXML.add xml, 'proposedAnalysisDate', CSDTP.parse(attributes["proposedanalysisdate"]).earliest_scalar
          dest = []
          sampleby = CSDR.split_mvf attributes, 'sampleby'
          destappnote = CSDR.split_mvf attributes, 'destanalysisapprovalnote'
          sampledescription = CSDR.split_mvf attributes, 'sampledescription'
          destappdate = CSDR.split_mvf attributes, 'destanalysisapproveddate'
          sampledate = CSDR.split_mvf attributes, 'sampledate'
          samplereturned = CSDR.split_mvf attributes, 'samplereturned'
          samplereturnedlocation = CSDR.split_mvf attributes, 'samplereturnedlocation'
          sampleby.each_with_index do |sby, index|
            dest << {"sampleBy" => CSXML::Helpers.get_authority('personauthorities', 'person', sby), "destAnalysisApprovalNote" => destappnote[index], "sampleDescription" => sampledescription[index], "destAnalysisApprovedDate" => CSDTP.parse(destappdate[index]).earliest_scalar, "sampleDate" => CSDTP.parse(sampledate[index]).earliest_scalar, "sampleReturned" => samplereturned[index], "sampleReturnedLocation" => samplereturnedlocation[index]}
          end
          CSXML.add_group_list xml, 'destAnalysis', dest
          CSXML.add xml, 'analysisMethod', attributes["analysismethod"]
          CSXML.add xml, 'analysisResults', attributes["analysisresults"]
        end
      end
    end
  end
end

