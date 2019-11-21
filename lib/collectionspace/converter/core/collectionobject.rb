module CollectionSpace
  module Converter
    module Core
      class CoreCollectionObject < CollectionObject
        ::CoreCollectionObject = CollectionSpace::Converter::Core::CoreCollectionObject
        def convert
          run do |xml|
            CoreCollectionObject.map(xml, attributes)
          end
        end

        def self.pairs
          {
            'objectnumber' => 'objectNumber',
            'numberofobjects' => 'numberOfObjects',
            'collection' => 'collection',
            'recordstatus' => 'recordStatus',
            'copynumber' => 'copyNumber',
            'editionnumber' => 'editionNumber',
            'phase' => 'phase',
            'sex' => 'sex'
          }
        end

        def self.simple_groups
          {
            'material' => 'material',
            'productionplace' => 'objectProductionPlace',
            'techattribute' => 'technicalAttribute',
            'technique' => 'technique'
          }
        end

        def self.simple_repeats
          {
            'briefdescription' => 'briefDescriptions',
            'comments' => 'comments',
            'fieldcollectioneventname' => 'fieldColEventNames',
            'form' => 'forms',
            'responsibledepartment' => 'responsibleDepartments',
            'style' => 'styles',
            'color' => 'colors'
          }
        end

        def self.map(xml, attributes)
          CSXML::Helpers.add_title(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreCollectionObject.pairs)
          CSXML::Helpers.add_simple_groups(xml, attributes, CoreCollectionObject.simple_groups)
          CSXML::Helpers.add_simple_repeats(xml, attributes, CoreCollectionObject.simple_repeats)

          CSXML::Helpers.add_measured_part_group_list(xml, attributes)
          CSXML::Helpers.add_date_group_list(
            xml, 'objectProductionDate', [CSDTP.parse(attributes['productiondate'])]
          )

          CSXML::Helpers.add_persons(
            xml,
            'contentPerson',
            split_mvf(attributes, 'contentperson'),
            :add_repeat
          )

          CSXML.add_group_list xml, 'textualInscription', [{
            "inscriptionContentInscriber" => CSXML::Helpers.get_authority(
              'personauthorities',
              'person',
              attributes["inscriber"]
            ),
            "inscriptionContentMethod" => attributes["method"],
          }]

          CSXML.add_group_list xml, 'objectProductionOrganization', [{
            "objectProductionOrganization" => CSXML::Helpers.get_authority(
              'orgauthorities',
              'organization',
              attributes["productionorg"]
            ),
            "objectProductionOrganizationRole" => attributes["organizationrole"],
          }]

          CSXML.add_group_list xml, 'objectProductionPerson', [{
            "objectProductionPerson" => CSXML::Helpers.get_authority(
              'personauthorities',
              'person',
              attributes["productionperson"]
            ),
            "objectProductionPersonRole" => attributes["personrole"],
          }]

          # not simple because 'objectProductionPeople' singularized as 'objectProductionPerson'
          CSXML.add_group_list xml, 'objectProductionPeople', [{"objectProductionPeople" => attributes["productionpeople"]}]

          CSXML.add_group_list xml, "objectComponent", [{
            "objectComponentName" => attributes["objectcomponentname"]
          }]

          CSXML.add_list xml, 'objectName', [{
            "objectName" => attributes["objectname"],
          }], 'Group'

          CSXML.add_repeat xml, 'objectStatus', [{
            "objectStatus" => attributes["objectstatus"]
          }], 'List'
          CSXML.add_list xml, 'otherNumber', [{
            "numberValue" => attributes["numbervalue"],
            "numberType" => attributes["numbertype"],
          }]
          CSXML.add_repeat xml, 'inventoryStatus', [{
            "inventoryStatus" => attributes["inventorystatus"]
          }], 'List'
          CSXML.add_repeat xml, 'publishTo', [{
            "publishTo" => attributes["publishto"]
          }], 'List'

        end
      end
    end
  end
end
