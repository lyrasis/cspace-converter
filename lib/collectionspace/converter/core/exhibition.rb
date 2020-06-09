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
            'organizerorganizationlocal' => ['organizers', 'organizer'],
            'organizerorganizationulan' => ['organizers', 'organizer'],
            'organizerpersonlocal' => ['organizers', 'organizer'],
            'organizerpersonulan' => ['organizers', 'organizer'],
            'sponsororganizationlocal' => ['sponsors', 'sponsor'],
            'sponsororganizationulan' => ['sponsors', 'sponsor'],
            'sponsorpersonlocal' => ['sponsors', 'sponsor'],
            'sponsorpersonulan' => ['sponsors', 'sponsor']

          }
          repeatstransforms = {
            'organizerorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'organizerorganizationulan' => {'authority' => ['orgauthorities', 'ulan_oa']},
            'organizerpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'organizerpersonulan' => {'authority' => ['personauthorities', 'ulan_pa']},
            'sponsororganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'sponsororganizationulan' => {'authority' => ['orgauthorities', 'ulan_oa']},
            'sponsorpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'sponsorpersonulan' => {'authority' => ['personauthorities', 'ulan_pa']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)

          # venueGroupList, venueGroup
          venuedata = {
            'venueorganizationlocal' => 'venue',
            'venueorganizationulan' => 'venue',
            'venueplacelocal' => 'venue',
            'venueplacetgn' => 'venue',
            'venuestoragelocation' => 'venue',
            'venuestoragelocationoffsite' => 'venue',
            'venueopeningdate' => 'venueOpeningDate',
            'venueclosingdate' => 'venueClosingDate',
            'venueattendance' => 'venueAttendance',
            'venueurl' => 'venueUrl'
          }

          venuetransforms = {
            'venueorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'venueorganizationulan' => {'authority' => ['orgauthorities', 'ulan_oa']},
            'venueplacelocal' => {'authority' => ['placeauthorities', 'place']},
            'venueplacetgn' => {'authority' => ['placeauthorities', 'tgn_place']},
            'venuestoragelocation' => {'authority' => ['locationauthorities', 'location']},
            'venuestoragelocationoffsite' => {'authority' => ['locationauthorities', 'offsite_sla']},
            'venueopeningdate' => {'special' => 'unstructured_date_stamp'},
            'venueclosingdate' => {'special' => 'unstructured_date_stamp'},
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'venue',
            venuedata,
            venuetransforms
	    )

          # workingGroupList, workingGroup, exhibitionPersonGroupList, exhibitionPersonGroup
          workingdata = {
            'workinggroupnote' => 'workingGroupNote',
            'workinggrouptitle' => 'workingGroupTitle',
            'exhibitionpersonrole' => 'exhibitionPersonRole',
            'exhibitionpersonorganizationlocal' => 'exhibitionPerson',
            'exhibitionpersonorganizationulan' => 'exhibitionPerson',
            'exhibitionpersonpersonlocal' => 'exhibitionPerson',
            'exhibitionpersonpersonulan' => 'exhibitionPerson'
          }
          exhibitionpersondata = [
            'exhibitionPersonRole',
            'exhibitionPerson'
          ]
          eptransforms = {
            'exhibitionpersonorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'exhibitionpersonorganizationulan' => {'authority' => ['orgauthorities', 'ulan_oa']},
            'exhibitionpersonpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'exhibitionpersonpersonulan' => {'authority' => ['personauthorities', 'ulan_pa']},
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

          # exhibitionReferenceGroupList, exhibitionReferenceGroup
          exhibitionreferencedata = {
            'exhibitionreferencelocal' => 'exhibitionReference',
            'exhibitionreferenceworldcat' => 'exhibitionReference',
            'exhibitionreferencenote' => 'exhibitionReferenceNote',
            'exhibitionreferencetype' => 'exhibitionReferenceType'
          }
          ertransforms = {
            'exhibitionreferencelocal' => {'authority' => ['citationauthorities', 'citation']},
            'exhibitionreferenceworldcat' => {'authority' => ['citationauthorities', 'worldcat']},
            'exhibitionreferencetype' => {'vocab' => 'exhibitionreferencetype'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'exhibitionReference',
            exhibitionreferencedata,
            ertransforms
          )

          # exhibitionSectionGroupList, exhibitionSectionGroup
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

          # exhibitionStatusGroupList, exhibitionStatusGroup 
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

          # exhibitionObjectGroupList, exhibitionObjectGroup
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
