# frozen_string_literal: true

module CollectionSpace
  module Converter
    module Extension
      # Contact Extension
      module Contact
        ::Contact = CollectionSpace::Converter::Extension::Contact
        # since this extension gets used in records in both Organization and
        # Person classes, it is not subclassed to a specific record type class
        extend self # make map_contact callable from refactored and unrefactored record mappers

        def map_contact(xml, attributes)
          # emailGroupList, emailGroup
          email_data = {
            'email' => 'email',
            'emailtype' => 'emailType'
          }

          CSXML.add_single_level_group_list(
            xml, attributes,
            'email',
            email_data
          )
          # telephoneNumberGroupList, telephoneNumberGroup
          telephone_data = {
            'telephonenumber' => 'telephoneNumber',
            'telephonenumbertype' => 'telephoneNumberType'
          }

          CSXML.add_single_level_group_list(
            xml, attributes,
            'telephoneNumber',
            telephone_data
          )
          # faxNumberGroupList, faxNumberGroup
          fax_data = {
            'faxnumber' => 'faxNumber',
            'faxnumbertype' => 'faxNumberType'
          }

          CSXML.add_single_level_group_list(
            xml, attributes,
            'faxNumber',
            fax_data
          )
          # webAddressGroupList, webAddressGroup
          webaddress_data = {
            'webaddress' => 'webAddress',
            'webaddresstype' => 'webAddressType'
          }

          CSXML.add_single_level_group_list(
            xml, attributes,
            'webAddress',
            webaddress_data
          )
          # addressGroupList, addressGroup
          address_data = {
            'addresstype' => 'addressType',
            'addressplace1' => 'addressPlace1',
            'addressplace2' => 'addressPlace2',
            'addressmunicipality' => 'addressMunicipality',
            'addressstateorprovince' => 'addressStateOrProvince',
            'addresspostcode' => 'addressPostCode',
            'addresscountry' => 'addressCountry'
          }

          CSXML.add_single_level_group_list(
            xml, attributes,
            'address',
            address_data
          )
        end
      end
    end
  end
end
