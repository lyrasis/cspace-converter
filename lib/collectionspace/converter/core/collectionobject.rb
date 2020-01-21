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
            'sex' => 'sex',
            'productionnote' => 'objectProductionNote',
            'fieldcollectionnote' => 'fieldCollectionNote',
            'fieldcollectionfeature' => 'fieldCollectionFeature'
          }
        end

        def self.simple_groups
          {
            'material' => 'material',
            'productionplace' => 'objectProductionPlace',
            'techattribute' => 'technicalAttribute',
            'technique' => 'technique',
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

        def self.simple_repeat_lists
          {
            'objectstatus' => 'objectStatus'
          }
        end

        def self.map(xml, attributes)
          CSXML::Helpers.add_title(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreCollectionObject.pairs)
          CSXML::Helpers.add_simple_groups(xml, attributes, CoreCollectionObject.simple_groups)
          CSXML::Helpers.add_simple_repeats(xml, attributes, CoreCollectionObject.simple_repeats)
          CSXML::Helpers.add_simple_repeats(xml, attributes, CoreCollectionObject.simple_repeat_lists, 'List')

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
          opp = []
          productionpeople = CSDR.split_mvf attributes, 'productionpeople'
          peoplerole = CSDR.split_mvf attributes, 'productionpeoplerole'
          productionpeople.each_with_index do |prodppl, index|
            opp << {"objectProductionPeople" => prodppl, "objectProductionPeopleRole" => peoplerole[index]}
          end
          CSXML.add_group_list xml, 'objectProductionPeople', opp

          object_name = []
          objectname = CSDR.split_mvf attributes, 'objectname'
          objectname.each_with_index do |obj, index|
            object_name << {"objectName" => obj}
          end
          CSXML.add_list xml, 'objectName', object_name, 'Group'

          other_number = []
          numbervalue = CSDR.split_mvf attributes, 'numbervalue'
          numbertype = CSDR.split_mvf attributes, 'numbertype'
          numbervalue.each_with_index do |numval, index|
            other_number << {"numberValue" => numval, "numberType" => numbertype[index]}
          end
          CSXML.add_list xml, 'otherNumber', other_number

          inventory_status = []
          inventstat = CSDR.split_mvf attributes, 'inventorystatus'
          inventstat.each_with_index do |inv, index|
            inventory_status << {"inventoryStatus" => CSXML::Helpers.get_vocab('inventorystatus', inv)}
          end
          CSXML.add_repeat xml, 'inventoryStatus', inventory_status, 'List'

          pbt = []
          publish = CSDR.split_mvf attributes, 'publishto'
          publish.each_with_index do |pb, index|
            pbt << {"publishTo" =>  CSXML::Helpers.get_vocab('publishto', pb)}
          end
          CSXML.add_repeat xml, 'publishTo', pbt, 'List'

          assoc_people = []
          assocpeople = CSDR.split_mvf attributes, 'assocpeople'
          assocpeopletype = CSDR.split_mvf attributes, 'assocpeopletype'
          assocpeople.each_with_index do |assc, index|
            assoc_people << {"assocPeople" =>  assc, "assocPeopleType" =>  assocpeopletype[index]}
          end
          CSXML.add_group_list xml, 'assocPeople', assoc_people

          CSXML.add_group_list xml, "objectComponent", [{
            "objectComponentName" => attributes["objectcomponentname"]
          }]

        end
      end
    end
  end
end
