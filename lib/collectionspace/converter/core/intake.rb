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
          CSXML.add xml, 'entryNumber', attributes["intake_entry_number"]
          CSXML.add xml, 'entryDate', attributes["entry_date"]
          CSXML.add xml, 'entryReason', attributes["entry_reason"].downcase!
          CSXML::Helpers.add_person xml, 'currentOwner', attributes["current_owner"] if attributes["current_owner"]
          CSXML.add xml, 'entryNote', attributes["entry_note"]
          CSXML.add xml, 'packingNote', attributes["packing_note"]
        end
      end
    end
  end
end
