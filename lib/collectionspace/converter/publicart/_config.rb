module CollectionSpace
  module Converter
    module PublicArt

      def self.registered_procedures
        [
          "CollectionObject",
          "Exhibition",
          "LoanIn",
          "LoanOut",
          "Media",
          "Intake",
          "Acquisition",
          "Group",
          "ValuationControl",
          "Movement",
          "ConditionCheck",
          "ObjectExit",
        ]
      end

      def self.registered_profiles
        {
          "cataloging" => {
            "Procedures" => {
              "CollectionObject" => {
                "identifier_field" => "objectNumber",
                "identifier" => "objectnumber",
                "title" => "title",
              },
            },
            "Authorities" => {
              "Person" => ["content_person", "inscriber", "objectproductionperson", "owners_person"],
              "Organization" => ["production_org", "owners_org"],
              "Concept" => [["material", "material_ca"]],
            },
            "Relationships" => [
              {
              },
            ],
          },
          "conditioncheck" => {
            "Procedures" => {
              "ConditionCheck" => {
                "identifier_field" => "conditionCheckRefNumber",
                "identifier" => "condition_check_reference_number",
                "title" => "condition_check_reference_number",
               },
             },
             "Authorities" => {
               "Person" => ["condition_checker"],
             },
             "Relationships" => [],
           },
          "exhibition" => {
            "Procedures" => {
              "Exhibition" => {
                "identifier_field" => "exhibitionNumber",
                "identifier" => "exhibition_number",
                "title" => "exhibition_number",
              },
            },
            "Authorities" => {
              "Organization" => ["organizer"],
            },
            "Relationships" => [],
          },
          "group" => {
            "Procedures" => {
              "Group" => {
                "identifier_field" => "title",
                "identifier" => "title",
                "title" => "title",
              },
            },
            "Authorities" => {
              "Person" => ["owner"],
            },
            "Relationships" => [],
          },
          "loanin" => {
            "Procedures" => {
              "LoanIn" => {
                "identifier_field" => "loanInNumber",
                "identifier" => "loan_in_number",
                "title" => "loan_in_number",
               },
             },
             "Authorities" => {
               "Person" => ["lender's_authorizer", "borrower's_authorizer"],
               "Organization" => ["lender"],
             },
             "Relationships" => [],
           },
           "loanout" => {
             "Procedures" => {
               "LoanOut" => {
                 "identifier_field" => "loanOutNumber",
                 "identifier" => "loan_out_number",
                 "title" => "loan_out_number",
               },
             },
             "Authorities" => {
               "Person" => ["lender's_authorizer", "borrower's_authorizer"],
               "Organization" => ["borrower"],
             },
             "Relationships" => [],
           },
           "media" => {
             "Procedures" => {
               "Media" => {
                 "identifier_field" => "identificationNumber",
                 "identifier" => "identificationnumber",
                 "title" => "identificationnumber",
               },
             },
             "Authorities" => {
             },
             "Relationships" => [],
           },
           "movement" => {
             "Procedures" => {
               "Movement" => {
                 "identifier_field" => "movementReferenceNumber",
                 "identifier" => "movementreferencenumber",
                 "title" => "movementreferencenumber",
               },
             },
             "Authorities" => {
               "Person" => ["movement_contact"],
             },
             "Relationships" => [],
           },
           "intake" => {
             "Procedures" => {
               "Intake" => {
                 "identifier_field" => "entryNumber",
                 "identifier" => "intake_entry_number",
                 "title" => "intake_entry_number",
               },
             },
             "Authorities" => {
              "Person" => ["current_owner"],
             },
             "Relationships" => [],
           },
           "objectexit" => {
             "Procedures" => {
               "ObjectExit" => {
                 "identifier_field" => "exitNumber",
                 "identifier" => "exit_number",
                 "title" => "exit_number",
               },
             },
             "Authorities" => {
              "Organization" => ["current_owner"],
             },
             "Relationships" => [],
           },
           "acquisition" => {
             "Procedures" => {
               "Acquisition" => {
                 "identifier_field" => "acquisitionReferenceNumber",
                 "identifier" => "acquisition_reference_number",
                 "title" => "acquisition_reference_number",
               },
             },
             "Authorities" => {
              "Person" => ["acquisition_authorizer", "owner"],
            },
            "Relationships" => [],
          },
          "valuationcontrol" => {
             "Procedures" => {
               "ValuationControl" => {
                 "identifier_field" => "valuationcontrolRefNumber",
                 "identifier" => "valuation_control_reference_number",
                 "title" => "valuation_control_reference_number",
               },
             },
             "Authorities" => {
              "Person" => ["source"],
            },
            "Relationships" => [],
          },
        }
      end

    end
  end
end
