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
          # not simple because 'objectProductionPeople' singularized as 'objectProductionPerson'
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
