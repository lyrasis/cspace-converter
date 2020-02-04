module CollectionSpace
  module Converter
    module Core
      class CoreExhibition < Exhibition
        ::CoreExhibition = CollectionSpace::Converter::Core::CoreExhibition
        def convert
          run do |xml|
            CoreExhibition.map(xml, attributes)
          end
        end

        def self.pairs
          {
            'exhibitionnumber' => 'exhibitionNumber',
            'title' => 'title',
            'type' => 'type',
            'planningnote' => 'planningNote',
            'curatorialnote' => 'curatorialNote',
            'generalnote' => 'generalNote',
            'boilerplatetext' => 'boilerplateText'
            
          }
        end

        def self.repeats
          {
            'organizerorganization' => ['organizers', 'organizer'],
            'organizerperson' => ['organizers', 'organizer'],
            'sponsororganization' => ['sponsors', 'sponsor'],
            'sponsorperson' => ['sponsors', 'sponsor']

          }
        end

        def self.map(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreExhibition.pairs,
          pairstransforms = {
            'type' => {'vocab' => 'exhibitiontype'},
          })
          CSXML::Helpers.add_repeats(xml, attributes, CoreExhibition.repeats,
          repeatstransforms = {
            'organizerorganization' => {'authority' => ['orgauthorities', 'organization']},
            'organizerperson' => {'authority' => ['personauthorities', 'person']},
            'sponsororganization' => {'authority' => ['orgauthorities', 'organization']},
            'sponsorperson' => {'authority' => ['personauthorities', 'person']}
          })
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

          workingdata = {
            'workinggroupnote' => 'workingGroupNote',
            'workinggrouptitle' => 'workingGroupTitle',
            'exhibitionpersonrole' => 'exhibitionPersonRole',
            'exhibitionpersonorganization' => 'exhibitionPerson',
            'exhibitionpersonperson' => 'exhibitionPerson'
          }
          exhibitionpersondata = [
            'exhibitionPersonRole',
            'exhibitionPerson'
          ]
          eptransforms = {
            'exhibitionpersonorganization' => {'authority' => ['orgauthorities', 'organization']},
            'exhibitionpersonperson' => {'authority' => ['personauthorities', 'person']},
            'exhibitionpersonrole' => {'vocab' => 'exhibitionpersonrole'}
          }
          CSXML.add_nested_group_lists(
            xml, attributes,
            'working',
            workingdata,
            'exhibitionPerson',
            exhibitionpersondata,
            eptransforms,
            sublist_suffix: 'GroupList',
            subgroup_suffix: 'Group'
          )
          galleryrotationdata = {
            'galleryrotationnote' => 'galleryRotationNote',
            'galleryrotationname' => 'galleryRotationName',
            'galleryrotationstartdate' => 'galleryRotationStartDate',
            'galleryrotationenddate' => 'galleryRotationEndDate'
          }
          CSXML.add_group_list_with_structured_date(
            xml, attributes,
            'galleryRotation',
            galleryrotationdata,
            ['galleryRotationStartDate', 'galleryRotationEndDate']
          )
          exhibitionreferencedata = {
            'exhibitionreference' => 'exhibitionReference',
            'exhibitionreferencenote' => 'exhibitionReferenceNote',
            'exhibitionreferencetype' => 'exhibitionReferenceType'
          }
          ertransforms = {
            'exhibitionreference' => {'authority' => ['citationauthorities', 'citation']},
            'exhibitionreferencetype' => {'vocab' => 'exhibitionreferencetype'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'exhibitionReference',
            exhibitionreferencedata,
            ertransforms
          )
          exhibitionsectiondata = {
            'exhibitionsectionname' => 'exhibitionSectionName',
            'exhibitionsectionobjects' => 'exhibitionSectionObjects',
            'exhibitionsectionlocation' => 'exhibitionSectionLocation',
            'exhibitionsectionnote' => 'exhibitionSectionNote',
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'exhibitionSection',
            exhibitionsectiondata,
          )
          exhibitionstatusdata = {
            'exhibitionstatus' => 'exhibitionStatus',
            'exhibitionstatusdate' => 'exhibitionStatusDate',
            'exhibitionstatusnote' => 'exhibitionStatusNote'
          }
          exhibitionstatustransforms = {
            'exhibitionstatus' => {'vocab' => 'exhibitionstatus'},
            'exhibitionstatusdate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'exhibitionStatus',
            exhibitionstatusdata,
            exhibitionstatustransforms
          )
          exhibitionobjectdata = {
            'exhibitionobjectnumber' => 'exhibitionObjectNumber',
            'exhibitionobjectname' => 'exhibitionObjectName',
            'exhibitionobjectconstreatment' => 'exhibitionObjectConsTreatment',
            'exhibitionobjectsection' => 'exhibitionObjectSection',
            'exhibitionobjectcase' => 'exhibitionObjectCase',
            'exhibitionobjectconscheckdate' => 'exhibitionObjectConsCheckDate',
            'exhibitionobjectmount' => 'exhibitionObjectMount',
            'exhibitionobjectseqnum' => 'exhibitionObjectSeqNum',
            'exhibitionobjectnote' => 'exhibitionObjectNote',
            'exhibitionobjectrotation' => 'exhibitionObjectRotation',

          }
          exhibitionobjecttransforms = {
            'exhibitionobjectconstreatment' => {'special' => 'upcase_first_char'},
            'exhibitionobjectconscheckdate' => {'special' => 'unstructured_date_stamp'},
            'exhibitionobjectmount' => {'special' => 'upcase_first_char'},
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'exhibitionObject',
            exhibitionobjectdata,
            exhibitionobjecttransforms
          )
        end
      end
    end
  end
end
