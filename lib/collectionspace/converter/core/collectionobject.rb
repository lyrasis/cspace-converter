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

        def self.map(xml, attributes)
          CSXML::Helpers.add_title(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreCollectionObject.pairs)
          CSXML::Helpers.add_simple_groups(xml, attributes, CoreCollectionObject.simple_groups)

          repeats = {
            'briefdescription' => ['briefDescriptions', 'briefDescription'],
            'comments' => ['comments', 'comment'],
            'fieldcollectioneventname' => ['fieldColEventNames', 'fieldColEventName'],
            'form' => ['forms', 'form'],
            'responsibledepartment' => ['responsibleDepartments', 'responsibleDepartment'],
            'style' => ['styles', 'style'],
            'color' => ['colors', 'color'],
            'objectstatus' => ['objectStatusList', 'objectStatus'],
            'contentperson' => ['contentPersons', 'contentPerson'],
            'inventorystatus' => ['inventoryStatusList', 'inventoryStatus'],
            'publishto' => ['publishToList', 'publishTo']

          }
          repeatstransforms = {
            'contentperson' => {'authority' => ['personauthorities', 'person']},
            'inventorystatus' => {'vocab' => 'inventorystatus'},
            'publishto' => {'vocab' => 'publishto'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeatstransforms)
          
          CSXML::Helpers.add_measured_part_group_list(xml, attributes)
          
          CSXML::Helpers.add_date_group_list(
            xml, 'objectProductionDate', [CSDTP.parse(attributes['productiondate'])]
          )
          
          textualinscriptiondata = {
            'inscriber' => 'inscriptionContentInscriber',
            'method' => 'inscriptionContentMethod'
          }
          textualinscriptiontransforms = {
            'inscriber' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'textualInscription',
            textualinscriptiondata,
            textualinscriptiontransforms
          )

          objectprodorgdata = {
            'productionorg' => 'objectProductionOrganization',
            'organizationrole' => 'objectProductionOrganizationRole'
          }
          objectprodorgtransforms = {
            'productionorg' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionOrganization',
            objectprodorgdata,
            objectprodorgtransforms
          )

          objectprodpersondata = {
            'productionperson' => 'objectProductionPerson',
            'personrole' => 'objectProductionPersonRole'
          }
          objectprodpersontransforms = {
            'productionperson' => {'authority' => ['personauthorities', 'person']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPerson',
            objectprodpersondata,
            objectprodpersontransforms
          )

          objectprodpeopledata = {
            'productionpeople' => 'objectProductionPeople',
            'productionpeoplerole' => 'objectProductionPeopleRole'
          } 
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPeople',
            objectprodpeopledata,
          )

          # objectNameList, objectNameGroup
          obj_name_data = {
            'objectnametype' => 'objectNameType',
            'objectnamesystem' => 'objectNameSystem',
            'objectname' => 'objectName',
            'objectnamecurrency' => 'objectNameCurrency',
            'objectnamenote' => 'objectNameNote',
            'objectnamelevel' => 'objectNameLevel',
            'objectnamelanguage' => 'objectNameLanguage'
          }
          obj_name_transforms = {
            'objectnamelanguage' => {'vocab' => 'languages'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectName',
            obj_name_data,
            obj_name_transforms,
            list_suffix: 'List'
          )

          # otherNumberList, otherNumber
          other_number_data = {
            'numbervalue' => 'numberValue',
            'numbertype' => 'numberType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'otherNumber',
            other_number_data,
            list_suffix: 'List',
            group_suffix: ''
          )

          assocpeopledata = {
            'assocpeople' => 'assocPeople',
            'assocpeopletype' => 'assocPeopleType'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocPeople',
            assocpeopledata,
          )

          objectcompdata = {
            'objectcomponentname' => 'objectComponentName'
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectComponent',
            objectcompdata,
          )
        end
      end
    end
  end
end
