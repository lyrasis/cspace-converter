module CollectionSpace
  module Converter
    module OHC
      class OHCAcquisition < Acquisition
        ::OHCAcquisition = CollectionSpace::Converter::OHC::OHCAcquisition
        def convert
          run do |xml|
            OHCAcquisition.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          CSXML.add xml, 'acquisitionReferenceNumber', attributes['acquisitionreferencenumber']
          CSXML.add xml, 'acquisitionNote', attributes['acquisitionnote']
          CSXML.add xml, 'acquisitionMethod', attributes['acquisitionmethod']

          aa = attributes['acquisitionauthorizer']
          CSXML::Helpers.add_person xml, 'acquisitionAuthorizer', aa if aa

          accdate = CSDTP.parse(attributes['accessiondate']) rescue nil
          CSXML::Helpers.add_date_group xml, 'accessionDate', accdate if accdate

          acqdate = CSDTP.parse(
            attributes['acquisitiondatestart'],
            attributes['acquisitiondateend']
          ) rescue nil
          acqdates = [acqdate].compact
          CSXML::Helpers.add_date_group_list xml, 'acquisitionDate', acqdates if acqdate

          app = [1, 2].map do |i|
            data = {}
            appdate = attributes["approvalstatus#{i}date"]
            data['approvalDate'] = appdate
            if appdate
              data['approvalDate'] = CSDTP.parse(appdate).earliest_scalar
            end
            status = attributes["approvalstatus#{i}status"]
            if status
              status = CSXML::Helpers.get_vocab('deaccessionapprovalstatus', status)
              data['approvalStatus'] = status
            end
            data
          end
          CSXML.add_group_list xml, 'approval', app

          owners = split_mvf(attributes, 'ownerorganization').map do |o|
            urn = CSXML::Helpers.get_authority('orgauthorities', 'organization', o)
            { 'owner' => urn }
          end
          owners.concat(split_mvf(attributes, 'ownerperson').map do |o|
            urn = CSXML::Helpers.get_authority('personauthorities', 'person', o)
            { 'owner' => urn }
          end)
          CSXML.add_repeat xml, 'owners', owners if owners.any?
        end
      end
    end
  end
end
