module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtExhibition < Exhibition
        ::PublicArtExhibition = CollectionSpace::Converter::PublicArt::PublicArtExhibition
        def redefined_fields
          @redefined.concat([
            # not in publicart
            'sponsor',
            'workingGroupTitle',
            'workingGroupNote',
            'exhibitionPerson',
            'exhibitionPersonRole',
            'exhibitionReference',
            'exhibitionReferenceType',
            'exhibitionReferenceNote',
            'exhibitionSectionName',
            'exhibitionSectionLocation',
            'exhibitionSectionObjects',
            'exhibitionSectionNote',
            'exhibitionStatus',
            'exhibitionStatusDate',
            'exhibitionStatusNote',
            'exhibitionObjectNumber',
            'exhibitionObjectName',
            'exhibitionObjectConsCheckDate',
            'exhibitionObjectConsTreatment',
            'exhibitionObjectMount',
            'exhibitionObjectSection',
            'exhibitionObjectCase',
            'exhibitionObjectSeqNum',
            'exhibitionObjectRotation',
            'exhibitionObjectNote'
            # overridden by publicart
          ])
          super
        end

        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:exhibitions_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/exhibition',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtExhibition.map_common(xml, attributes, redefined_fields)
            end

            xml.send(
              'ns2:exhibitions_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/exhibition/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtExhibition.map_publicart(xml, attributes)
            end
          end
        end

        def self.map_common(xml, attributes, redefined)
          CoreExhibition.map_common(xml, attributes.merge(redefined))
        end

        def self.map_publicart(xml, attributes)
          #exhibitionSupportGroupList, exhibitionSupportGroup
          exhibitionsupport_data = {
            "exhibitionsupportnote" => "exhibitionSupportNote",
            "exhibitionsupportorganization" => "exhibitionSupport",
            "exhibitionsupportperson" => "exhibitionSupport"
          }
          exhibitionsupport_transforms = {
            'exhibitionsupportorganization' => {'authority' => ['orgauthorities', 'organization']},
            'exhibitionsupportperson' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'exhibitionSupport',
            exhibitionsupport_data,
            exhibitionsupport_transforms
          )
        end

      end
    end
  end
end
