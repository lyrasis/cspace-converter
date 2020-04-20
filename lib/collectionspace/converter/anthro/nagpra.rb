module CollectionSpace
  module Converter
    module Anthro
      class AnthroNagpra < Nagpra
        ::AnthroNagpra = CollectionSpace::Converter::Anthro::AnthroNagpra
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:claims_common",
                "xmlns:ns2" => "http://collectionspace.org/services/claim",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              AnthroNagpra.map(xml, attributes)
            end

            xml.send(
                "ns2:claims_nagpra",
                "xmlns:ns2" => "http://collectionspace.org/services/claim/domain/nagpra",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              AnthroNagpra.extension(xml, attributes)
            end
          end
        end

        def self.extension(xml, attributes)
          pairs = {
            'dispositionpossibilitiesdiscussednote' => 'dispositionPossibilitiesDiscussedNote',
            'dispositionpossibilitiesdiscussed' => 'dispositionPossibilitiesDiscussed',
            'surroundingtribescontactednote' => 'surroundingTribesContactedNote',
            'surroundingtribescontacted' => 'surroundingTribesContacted',
            'workingteamnotifiednote' => 'workingTeamNotifiedNote',
            'workingteamnotified' => 'workingTeamNotified',
            'sitefileresearchcompletednote' => 'siteFileResearchCompletedNote',
            'sitefileresearchcompleted' => 'siteFileResearchCompleted',
            'accessionfileresearchcompletednote' => 'accessionFileResearchCompletedNote',
            'accessionfileresearchcompleted' => 'accessionFileResearchCompleted',
            'objectslocatedandcountednote' => 'objectsLocatedAndCountedNote',
            'objectslocatedandcounted' => 'objectsLocatedAndCounted',
            'objectsconsolidatednote' => 'objectsConsolidatedNote',
            'objectsconsolidated' => 'objectsConsolidated',
            'objectsphotographednote' => 'objectsPhotographedNote',
            'objectsphotographed' => 'objectsPhotographed',
            'registrationdocumentsdraftednote' => 'registrationDocumentsDraftedNote',
            'registrationdocumentsdrafted' => 'registrationDocumentsDrafted',
            'tribecontactedforpackingpreferencesnote' => 'tribeContactedForPackingPreferencesNote',
            'tribecontactedforpackingpreferences' => 'tribeContactedForPackingPreferences',
            'datearrangedfortransfernote' => 'dateArrangedForTransferNote',
            'datearrangedfortransfer' => 'dateArrangedForTransfer',
            'objectsmarkedasdeaccessionednote' => 'objectsMarkedAsDeaccessionedNote',
            'objectsmarkedasdeaccessioned' => 'objectsMarkedAsDeaccessioned',
            'documentsarchivednote' => 'documentsArchivedNote',
            'documentsarchived' => 'documentsArchived',
            'nagpraclaimname' => 'nagpraClaimName'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
          repeats = {
            'nagpraclaimtype' => ['nagpraClaimTypes', 'nagpraClaimType'],
            'nagpraclaimnote' => ['nagpraClaimNotes', 'nagpraClaimNote'],
          }
          repeats_transforms = {
            'nagpraclaimtype' => {'vocab' => 'nagpraclaimtype'},
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeats_transforms)
          #nagpraClaimAltNameGroupList, nagpraClaimAltNameGroup
          nagpraclaimalt_data = {
            "nagpraclaimaltname"  => "nagpraClaimAltName",
            "nagpraclaimaltnamenote" => "nagpraClaimAltNameNote"
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimAltName',
            nagpraclaimalt_data
          )
          #nagpraClaimSiteGroupList, nagpraClaimSiteGroup
          nagpraclaimsite_data = {
            "nagpraclaimsitename"  => "nagpraClaimSiteName",
            "nagpraclaimsitenote" => "nagpraClaimSiteNote"
          }
          nagpraclaimsite_transforms = {
            "nagpraclaimsitename" => {'authority' => ['placeauthorities', 'place']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimSite',
            nagpraclaimsite_data,
            nagpraclaimsite_transforms
          )
          #nagpraClaimGroupGroupList, nagpraClaimGroupGroup
          nagpraclaimgroup_data = {
            "nagpraclaimgroupnote"  => "nagpraClaimGroupNote",
            "nagpraclaimgroupname" => "nagpraClaimGroupName"
          }
          nagpraclaimgroup_transforms = {
            "nagpraclaimgroupname" => {'authority' => ['conceptauthorities', 'ethculture']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimGroup',
            nagpraclaimgroup_data,
            nagpraclaimgroup_transforms
          )
          #nagpraClaimPeriodGroupList, nagpraClaimPeriodGroup
          nagpraclaimperiod_data = {
            "nagpraclaimperioddate"  => "nagpraClaimPeriodDateGroup",
            "nagpraclaimperiodnote" => "nagpraClaimPeriodNote"
          }
          nagpraclaimperiod_transforms = {
            "nagpraclaimperioddate" => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimPeriod',
            nagpraclaimperiod_data,
            nagpraclaimperiod_transforms
          )
          #nagpraClaimInitialResponseGroupList, nagpraClaimInitialResponseGroup
          nagpraclaiminitialresponse_data = {
            "nagpraclaiminitialresponsedate"  => "nagpraClaimInitialResponseDate",
            "nagpraclaiminitialresponsenote" => "nagpraClaimInitialResponseNote"
          }
          nagpraclaiminitialresponse_transforms = {
            "nagpraclaiminitialresponsedate" => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimInitialResponse',
            nagpraclaiminitialresponse_data,
            nagpraclaiminitialresponse_transforms
          )
          #nagpraClaimSentToLocalGroupList, nagpraClaimSentToLocalGroup
          nagpraclaimsenttolocal_data = {
            "nagpraclaimsenttolocaldate"  => "nagpraClaimSentToLocalDate",
            "nagpraclaimsenttolocalnote" => "nagpraClaimSentToLocalNote"
          }
          nagpraclaimsenttolocal_transforms = {
            "nagpraclaimsenttolocaldate" => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimSentToLocal',
            nagpraclaimsenttolocal_data,
            nagpraclaimsenttolocal_transforms
          )
          #nagpraClaimLocalRecGroupList, nagpraClaimLocalRecGroup
          nagpraclaimlocalrec_data = {
            "nagpraclaimlocalrecdate"  => "nagpraClaimLocalRecDate",
            "nagpraclaimlocalrecnote" => "nagpraClaimLocalRecNote"
          }
          nagpraclaimlocalrec_transforms = {
            "nagpraclaimlocaleecdate" => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimLocalRec',
            nagpraclaimlocalrec_data,
            nagpraclaimlocalrec_transforms
          )
          #nagpraClaimSentToNatlGroupList, nagpraClaimSentToNatlGroup
          nagpraclaimsenttonatl_data = {
            "nagpraclaimsenttonatldate"  => "nagpraClaimSentToNatlDate",
            "nagpraclaimsenttonatlnote" => "nagpraClaimSentToNatlNote"
          }
          nagpraclaimsenttonatl_transforms = {
            "nagpraclaimsenttonatldate" => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimSentToNatl',
            nagpraclaimsenttonatl_data,
            nagpraclaimsenttonatl_transforms
          )
          #nagpraClaimNatlRespGroupList, nagpraClaimNatlRespGroup
          nagpraclaimnatlresp_data = {
            "nagpraclaimnatlrespdate"  => "nagpraClaimNatlRespDate",
            "nagpraclaimnatlrespnote" => "nagpraClaimNatlRespNote"
          }
          nagpraclaimnatlresp_transforms = {
            "nagpraclaimnatlrespdate" => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimNatlResp',
            nagpraclaimnatlresp_data,
            nagpraclaimnatlresp_transforms
          )
          #nagpraClaimNatlApprovalGroupList, nagpraClaimNatlApprovalGroup
          nagpraclaimnatlapproval_data = {
            "nagpraclaimnatlapprovaldate"  => "nagpraClaimNatlApprovalDate",
            "nagpraclaimnatlapprovalnote" => "nagpraClaimNatlApprovalNote"
          }
          nagpraclaimnatlapproval_transforms = {
            "nagpraclaimnatlapprovaldate" => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimNatlApproval',
            nagpraclaimnatlapproval_data,
            nagpraclaimnatlapproval_transforms
          )
          #nagpraClaimNoticeGroupList, nagpraClaimNoticeGroup
          nagpraclaimnotice_data = {
            "nagpraclaimnoticedate"  => "nagpraClaimNoticeDate",
            "nagpraclaimnoticedatetype" => "nagpraClaimNoticeDateType",
            "nagpraclaimnoticenote" => "nagpraClaimNoticeNote"
          }
          nagpraclaimnotice_transforms = {
            "nagpraclaimnoticedate" => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimNotice',
            nagpraclaimnotice_data,
            nagpraclaimnotice_transforms
          )
          #nagpraClaimTransferGroupList, nagpraClaimTransferGroup
          nagpraclaimtransfer_data = {
            "nagpraclaimtransferdate"  => "nagpraClaimTransferDate",
            "nagpraclaimtransfernote" => "nagpraClaimTransferNote"
          }
          nagpraclaimtransfer_transforms = {
            "nagpraclaimtransferdate" => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'nagpraClaimTransfer',
            nagpraclaimtransfer_data,
            nagpraclaimtransfer_transforms
          )
        end

        def self.map(xml, attributes)
          pairs = {
            'claimnumber' => 'claimNumber'
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
          #claimantGroupList, claimantGroup
          claimant_data = {
            "claimantnote"  => "claimantNote",
            "claimfiledbyperson" => "claimFiledBy",
            "claimfiledbyorganization" => "claimFiledBy",
            "claimfiledonbehalfofperson" => "claimFiledOnBehalfOf",
            "claimfiledonbehalfoforganization" => "claimFiledOnBehalfOf",
          },
          claimant_transforms = {
            "claimfiledbyperson" => {'authority' => ['personauthorities', 'person']},
            "claimfiledbyorganization" => {'authority' => ['orgauthorities', 'organization']},
            "claimfiledonbehalfofperson" => {'authority' => ['personauthorities', 'person']},
            "claimfiledonbehalfoforganization" => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'claimant',
            claimant_data,
            claimant_transforms
          )
          #claimReceivedGroupList,claimReceivedGroup
          claimreceived_data = {
            "claimreceivednote"  => "claimReceivedNote",
            "claimreceiveddate" => "claimReceivedDate"
          },
          claimreceived_transforms = {
            "claimreceiveddate" => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'claimReceived',
            claimreceived_data,
            claimreceived_transforms
          )
         end
       end
     end
   end
 end
