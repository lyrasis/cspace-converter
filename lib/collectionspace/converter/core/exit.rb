module CollectionSpace
  module Converter
    module Core
      class CoreObjectExit < ObjectExit
        ::CoreObjectExit = CollectionSpace::Converter::Core::CoreObjectExit
        def convert
          run do |xml|
            CoreObjectExit.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'exitNumber', attributes["exitnumber"]
          CSXML::Helpers.add_person xml, 'currentOwner', attributes["currentowner"] rescue nil
          CSXML::Helpers.add_organization xml, 'currentOwner', attributes["currentownerorg"] rescue nil
          CSXML::Helpers.add_person xml, 'depositor', attributes["depositor"] rescue nil
          CSXML::Helpers.add_organization xml, 'depositor', attributes["depositororg"] rescue nil
          CSXML.add_repeat xml, 'exitMethods', [{'exitMethod' => attributes['exitmethod']}]
          CSXML.add xml, 'exitNote', attributes["exitnote"] 
          CSXML.add xml, 'exitReason', attributes["exitreason"]
          CSXML.add xml, 'packingNote', attributes["packingnote"]
          CSXML.add xml, 'displosalNewObjectNumber', attributes["displosalnewobjectnumber"]
          approval = []
          approvalgroup = split_mvf attributes, 'deaccessionapprovalgroup'
          approvalstatus = split_mvf attributes, 'deaccessionapprovalstatus'
          approvaldate = split_mvf attributes, 'deaccessionapprovaldate'
          approvalgroup.each_with_index do |grp, index|
            approval << { "deaccessionApprovalGroup" => CSXML::Helpers.get_vocab('deaccessionapprovalgroup', grp), "deaccessionApprovalStatus" => CSXML::Helpers.get_vocab('deaccessionapprovalstatus', approvalstatus[index]), "deaccessionApprovalDate" => CSDTP.parse(approvaldate[index]).earliest_scalar}
          end
          CSXML.add_group_list xml, 'deacApproval', approval
          CSXML::Helpers.add_person xml, 'deaccessionAuthorizer', attributes["deaccessionauthorizer"]
          CSXML.add xml, 'authorizationDate', CSDTP.parse(attributes['authorizationdate']).earliest_scalar 
          CSXML.add xml, 'deaccessionDate', CSDTP.parse(attributes['deaccessiondate']).earliest_scalar
          CSXML.add xml, 'disposalDate', CSDTP.parse(attributes['disposaldate']).earliest_scalar      
          CSXML.add xml, 'disposalMethod', CSXML::Helpers.get_vocab('disposalmethod', attributes["disposalmethod"])
          CSXML.add xml, 'displosalReason', attributes["disposalreason"]
          CSXML.add xml, 'displosalProvisos', attributes["disposalprovisos"]
          CSXML.add xml, 'displosalProvisos', attributes["disposalprovisos"]
          CSXML::Helpers.add_person xml, 'disposalProposedRecipient', attributes["disposalproposedrecipient"] rescue nil
          CSXML::Helpers.add_organization xml, 'disposalProposedRecipient', attributes["disposalproposedrecipientorg"] rescue nil
          CSXML::Helpers.add_person xml, 'disposalRecipient', attributes["disposalrecipient"] rescue nil
          CSXML::Helpers.add_organization xml, 'disposalRecipient', attributes["disposalrecipientorg"] rescue nil
          CSXML.add xml, 'displosalNote', attributes["disposalnote"]
          CSXML.add xml, 'disposalCurrency', CSXML::Helpers.get_vocab('currency', attributes['disposalcurrency'])
          CSXML.add xml, 'displosalValue', attributes['disposalvalue']
          CSXML.add xml, 'groupDisposalCurrency', CSXML::Helpers.get_vocab('currency', attributes['groupdisposalcurrency'])
          CSXML.add xml, 'groupDisplosalValue', attributes['groupdisposalvalue']
        end
      end
    end
  end
end

