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
          # TODO
        end
      end
    end
  end
end
