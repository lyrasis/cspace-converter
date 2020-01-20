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
  
        def self.pairs
          {
            'conditioncheckrefnumber' => 'conditionCheckRefNumber',
            'conditioncheckassessmentdate' => 'conditionCheckAssessmentDate',
            'conditioncheckmethod' => 'conditionCheckMethod',
            'conditionchecknote' => 'conditionCheckNote',
            'conditioncheckreason' => 'conditionCheckReason',
            'conditioncheckerperson' => 'conditionChecker',
            'conditioncheckerorganization' => 'conditionChecker',
            'objectauditcategory' => 'objectAuditCategory',
            'conservationtreatmentpriority' => 'conservationTreatmentPriority',
            'nextconditioncheckdate' => 'nextConditionCheckDate',
            'displayrecommendations' => 'displayRecommendations',
            'envrecommendations' => 'envRecommendations',
            'handlingrecommendations' => 'handlingRecommendations',
            'packingrecommendations' => 'packingRecommendations',
            'securityrecommendations' => 'securityRecommendations',
            'specialrequirements' => 'specialRequirements',
            'storagerequirements' => 'storageRequirements',
            'legalrequirements' => 'legalRequirements'
          }
        end

        def self.simple_groups
          {
          }
        end

        def self.simple_repeats
          {
          }
        end

        def self.simple_repeat_lists
          {
          }
        end


        def self.map(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreCollectionObject.pairs, 
          pairstransforms = {
            'conditioncheckassessmentdate' => {'special' => 'unstructured_date_stamp'},
            'conditioncheckerperson' => {'authority' => ['personauthorities', 'person']},
            'conditioncheckerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'nextconditioncheckdate' => {'special' => 'unstructured_date_stamp'},
            
          })
          CSXML::Helpers.add_simple_groups(xml, attributes, CoreCollectionObject.simple_groups)
          CSXML::Helpers.add_simple_repeats(xml, attributes, CoreCollectionObject.simple_repeats)
          CSXML::Helpers.add_simple_repeats(xml, attributes, CoreCollectionObject.simple_repeat_lists, 'List')

          overall_completeness = {
            'completeness' => 'completeness',
            'completenessnote' => 'completenessNote',
            'completenessdate' => 'completenessDate'
          }
  
          completenesstransforms = {
            'completenessdate' => {'special' => 'unstructured_date_string'}
          }
        
          CSXML.prep_and_add_single_level_group_list(
            xml,
            attributes,
            'completeness',
            overall_completeness,
            completenesstransforms
          ) 
=begin
          overall_completeness = []
          completeness = CSDR.split_mvf attributes, 'completeness'
          completenessnote = CSDR.split_mvf attributes, 'completenessnote'
          completenessdate = CSDR.split_mvf attributes, 'completenessdate'
          completeness.each_with_index do |cmplt, index|
            overall_completeness << {"completeness" => cmplt, "completenessNote" => completenessnote[index], "completenessDate" => CSDTP.parse(completenessdate[index]).earliest_scalar}
          end
          CSXML.add_group_list xml, 'completeness', overall_completeness
=end
          overall_condition = []
          condition = CSDR.split_mvf attributes, 'condition'
          conditiondate = CSDR.split_mvf attributes, 'conditiondate' 
          conditionnote = CSDR.split_mvf attributes, 'conditionnote'
          condition.each_with_index do |cndtn, index|
            overall_condition << {"condition" => cndtn, "conditionNote" => conditionnote[index], "conditionDate" => CSDTP.parse(conditiondate[index]).earliest_scalar}
          end
          CSXML.add_group_list xml, 'conditionCheck', overall_condition
          overall_env = []
          envnote = CSDR.split_mvf attributes, 'envconditionnote'
          envdate = CSDR.split_mvf attributes, 'envconditionnotedate'
          envnote.each_with_index do |env, index|
            overall_env << {"envConditionNote" => env, "envConditionNoteDate" => CSDTP.parse(envdate[index]).earliest_scalar}
          end
          CSXML.add_group_list xml, 'envConditionNote', overall_env
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
          overall_salvage = []
          salvagecode = CSDR.split_mvf attributes, 'salvageprioritycode'
          salvagedate = CSDR.split_mvf attributes, 'salvageprioritycodedate'        
          salvagecode.each_with_index do |slvg, index|
            overall_salvage << {"salvagePriorityCode" => slvg, "salvagePriorityCodeDate" => CSDTP.parse(salvagedate[index]).earliest_scalar}
          end
          CSXML.add_group_list xml, 'salvagePriorityCode', overall_salvage
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
