module CollectionSpace
  module Converter
    module Core
      class CoreConditionCheck < ConditionCheck
        ::CoreConditionCheck = CollectionSpace::Converter::Core::CoreConditionCheck
        def convert
          run do |xml|
            CoreConditionCheck.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'conditionCheckRefNumber', attributes["conditioncheckrefnumber"]
          CSXML.add xml, 'conditionCheckAssessmentDate', CSDTP.parse(attributes['conditioncheckassessmentdate']).earliest_scalar
          CSXML.add xml, 'conditionCheckMethod', attributes["conditioncheckmethod"]
          CSXML.add xml, 'conditionCheckNote', attributes["conditionchecknote"]
          CSXML.add xml, 'conditionCheckReason', attributes["conditioncheckreason"]
          CSXML.add xml, 'objectAuditCategory', attributes["objectauditcategory"]
          overall_completeness = []
          completeness = CSDR.split_mvf attributes, 'completeness'
          completenessnote = CSDR.split_mvf attributes, 'completenessnote'
          completenessdate = CSDR.split_mvf attributes, 'completenessdate'
          completeness.each_with_index do |cmplt, index|
            overall_completeness << {"completeness" => cmplt, "completenessNote" => completenessnote[index], "completenessDate" => CSDTP.parse(completenessdate[index]).earliest_scalar}
          end
          CSXML.add_group_list xml, 'completeness', overall_completeness
          overall_condition = []
          condition = CSDR.split_mvf attributes, 'condition'
          conditiondate = CSDR.split_mvf attributes, 'conditiondate' 
          conditionnote = CSDR.split_mvf attributes, 'conditionnote'
          condition.each_with_index do |cndtn, index|
            overall_condition << {"condition" => cndtn, "conditionNote" => conditionnote[index], "conditionDate" => CSDTP.parse(conditiondate[index]).earliest_scalar}
          end
          CSXML.add_group_list xml, 'conditionCheck', overall_condition
          CSXML.add xml, 'conservationTreatmentPriority', attributes["conservationtreatmentpriority"]
          overall_env = []
          envnote = CSDR.split_mvf attributes, 'envconditionnote'
          envdate = CSDR.split_mvf attributes, 'envconditionnotedate'
          envnote.each_with_index do |env, index|
            overall_env << {"envConditionNote" => env, "envConditionNoteDate" => CSDTP.parse(envdate[index]).earliest_scalar}
          end
          CSXML.add_group_list xml, 'envConditionNote', overall_env
          CSXML.add xml, 'nextConditionCheckDate', CSDTP.parse(attributes['nextconditioncheckdate']).earliest_scalar
          overall_tech = []
          techassessment = CSDR.split_mvf attributes, 'techassessment'
          techdate = CSDR.split_mvf attributes, 'techassessmentdate'      
          techassessment.each_with_index do |tch, index|
            overall_tech << {"techAssessment" => tch, "techAssessmentDate" => CSDTP.parse(techdate[index]).earliest_scalar}
          end
          CSXML.add_group_list xml, 'techAssessment', overall_tech
          overall_hazard = []
          hazard = CSDR.split_mvf attributes, 'hazard'
          hazarddate = CSDR.split_mvf attributes, 'hazarddate'
          hazardnote = CSDR.split_mvf attributes, 'hazardnote'  
          hazard.each_with_index do |hzd, index|
            overall_hazard << {"hazard" => hzd, "hazardDate" => CSDTP.parse(techdate[index]).earliest_scalar, "hazardNote" => hazardnote[index]}
          end
          CSXML.add_group_list xml, 'hazard', overall_hazard
          CSXML.add xml, 'displayRecommendations', attributes["displayrecommendations"]
          CSXML.add xml, 'envRecommendations', attributes["envrecommendations"]
          CSXML.add xml, 'handlingRecommendations', attributes["handlingrecommendations"]
          CSXML.add xml, 'packingRecommendations', attributes["packingrecommendations"]
          CSXML.add xml, 'securityRecommendations', attributes["securityrecommendations"]
          CSXML.add xml, 'specialRequirements', attributes["specialrequirements"]
          CSXML.add xml, 'storageRequirements', attributes["storagerequirements"]
          overall_salvage = []
          salvagecode = CSDR.split_mvf attributes, 'salvageprioritycode'
          salvagedate = CSDR.split_mvf attributes, 'salvageprioritycodedate'        
          salvagecode.each_with_index do |slvg, index|
            overall_salvage << {"salvagePriorityCode" => slvg, "salvagePriorityCodeDate" => CSDTP.parse(salvagedate[index]).earliest_scalar}
          end
          CSXML.add_group_list xml, 'salvagePriorityCode', overall_salvage
          CSXML.add xml, 'legalRequirements', attributes["legalrequirements"]
          overall_legal = []
          reqsheld = CSDR.split_mvf attributes, 'legalreqsheld'
          begindate = CSDR.split_mvf attributes, 'legalreqsheldbegindate'
          endate = CSDR.split_mvf attributes, 'legalreqsheldenddate'
          renewdate = CSDR.split_mvf attributes, 'legalreqsheldrenewdate'
          reqsnumber = CSDR.split_mvf attributes, 'legalreqsheldnumber'
          reqsheld.each_with_index do |lgl, index|
            overall_legal << {"legalReqsHeld" => lgl, "legalReqsHeldBeginDate" => CSDTP.parse(begindate[index]).earliest_scalar, "legalReqsHeldRenewDate" => CSDTP.parse(renewdate[index]).earliest_scalar, "legalReqsHeldEndDate" => CSDTP.parse(endate[index]).earliest_scalar, "legalReqsHeldNumber" => reqsnumber[index]}
          end
          CSXML.add_group_list xml, 'legalReqsHeld', overall_legal
        end
      end
    end
  end
end
