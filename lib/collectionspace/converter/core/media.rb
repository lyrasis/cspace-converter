module CollectionSpace
  module Converter
    module Core
      class CoreMedia < Media
        ::CoreMedia = CollectionSpace::Converter::Core::CoreMedia
        def convert
          run do |xml|
            CoreMedia.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'identificationNumber', attributes["identificationnumber"]
          CSXML.add xml, 'title', attributes["title"]
          CSXML.add xml, 'coverage', attributes["coverage"]
          CSXML.add xml, 'description', scrub_fields([attributes["description"]])
          CSXML.add xml, 'externalUrl', attributes["externalurl"]
        end
      end
    end
  end
end
