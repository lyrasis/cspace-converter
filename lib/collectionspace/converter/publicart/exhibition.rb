module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtExhibition < Exhibition
        ::PublicArtExhibition = CollectionSpace::Converter::PublicArt::PublicArtExhibition
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:exhibitions_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/exhibition',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtExhibition.map(xml, attributes)
            end

            xml.send(
              'ns2:exhibitions_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/exhibition/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              PublicArtExhibition.extension(xml, attributes)
            end
          end
        end
        def self.map(xml, attributes)
          pairs = {
            'exhibitionnumber' => 'exhibitionNumber',
            'title' => 'title',
            'type' => 'type',
            'planningnote' => 'planningNote',
            'curatorialnote' => 'curatorialNote',
            'generalnote' => 'generalNote',
            'boilerplatetext' => 'boilerplateText'
          }

          pairstransforms = {
            'type' => {'vocab' => 'exhibitiontype'},
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairstransforms)

          repeats = {
            'organizerorganization' => ['organizers', 'organizer'],
            'organizerperson' => ['organizers', 'organizer'],

          }
          repeatstransforms = {
            'organizerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'organizerperson' => {'authority' => ['personauthorities', 'person']},
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)

          # venueGroupList, venueGroup
          venuedata = {
            'venueorganization' => 'venue',
            'venueplace' => 'venue',
            'venuestoragelocation' => 'venue',
            'venueopeningdate' => 'venueOpeningDate',
            'venueclosingdate' => 'venueClosingDate',
            'venueattendance' => 'venueAttendance',
            'venueurl' => 'venueUrl'
          }

          venuetransforms = {
            'venueorganization' => {'authority' => ['orgauthorities', 'organization']},
            'venueplace' => {'authority' => ['placeauthorities', 'place']},
            'venuestoragelocation' => {'authority' => ['locationauthorities', 'location']},
            'venueopeningdate' => {'special' => 'unstructured_date_stamp'},
            'venueclosingdate' => {'special' => 'unstructured_date_stamp'},
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'venue',
            venuedata,
            venuetransforms
	    )

          # galleryRotationGroupList, galleryRotationGroup
          galleryrotationdata = {
            'galleryrotationnote' => 'galleryRotationNote',
            'galleryrotationname' => 'galleryRotationName',
            'galleryrotationstartdate' => 'galleryRotationStartDateGroup',
            'galleryrotationenddate' => 'galleryRotationEndDateGroup'
          }
          galleryrotation_transforms = {
            'galleryrotationstartdate' => {'special' => 'structured_date'},
            'galleryrotationenddate' => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'galleryRotation',
            galleryrotationdata,
            galleryrotation_transforms
          )
        end

        def self.extension(xml, attributes)
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
