# frozen_string_literal: true

require_relative '../core/collectionobject'

module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtCollectionObject < CoreCollectionObject
        ::PublicArtCollectionObject = CollectionSpace::Converter::PublicArt::PublicArtCollectionObject
        def initialize(attributes, config = {})
          super(attributes, config)
          @redefined = [
            # not in publicart
            'objectcomponentname',
            'objectcomponentinformation',
            'inscriptioncontentlanguage',
            'inscriptioncontentscript',
            'inscriptioncontentmethod',
            'inscriptioncontentinterpretation',
            'inscriptioncontenttranslation',
            'inscriptioncontenttransliteration',
            'inscriptiondescription',
            'inscriptiondescriptioninscriber',
            'inscriptiondescriptionposition',
            'inscriptiondescriptiontype',
            'inscriptiondescriptionmethod',
            'inscriptiondescriptioninterpretation',
            'objectproductionreason',
            'objectproductionpeople',
            'objectproductionpeoplerole',
            'assocactivity',
            'assocactivitytype',
            'assocactivitynote',
            'assocobject',
            'assocobjecttype',
            'assocobjectnote',
            'assocconcept',
            'assocconcepttype',
            'assocconceptnote',
            'assocculturalcontext',
            'assocculturalcontexttype',
            'assocculturalcontextnote',
            'assocorganization',
            'assocorganizationtype',
            'assocorganizationnote',
            'assocpeople',
            'assocpeopletype',
            'assocpeoplenote',
            'assocperson',
            'assocpersontype',
            'assocpersonnote',
            'assocplace',
            'assocplacetype',
            'assocplacenote',
            'assoceventname',
            'assoceventnametype',
            'assoceventorganization',
            'assoceventpeople',
            'assoceventperson',
            'assoceventplace',
            'assoceventnote',
            'assocdatetype',
            'assocdatenote',
            'objecthistorynote',
            'usage',
            'usagenote',
            'ownershipaccess',
            'ownershipcategory',
            'ownershipplace',
            'ownershipexchangemethod',
            'ownershipexchangenote',
            'ownershipexchangepricecurrency',
            'ownershipexchangepricevalue',
            'ownerspersonalexperience',
            'ownerspersonalresponse',
            'ownersreference',
            'ownerscontributionnote',
            'viewersrole',
            'viewerspersonalexperience',
            'viewerspersonalresponse',
            'viewersreference',
            'viewerscontributionnote',
            'fieldcollectionmethod',
            'fieldcollectionplace',
            'fieldcollectionsource',
            'fieldcollector',
            'fieldcollectionnumber',
            'fieldcoleventname',
            'fieldcollectionfeature',
            'fieldcollectionnote',
            'inscriptioncontentdategroup',
            'inscriptiondescriptiondategroup',
            'assocstructureddategroup',
            'ownershipdategroup',
            'fieldcollectiondategroup',
            # overridden by publicart
            'responsibledepartment',
            'computedcurrentlocation',
            'objectname',
            'material',
            'measuredby',
            'contentconcept',
            'contentperson',
            'contentorganization',
            'inscriptioncontentinscriber',
            'objectproductionperson',
            'objectproductionorganization',
            'owner'
          ]
        end

        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:collectionobjects_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              map_common(xml, attributes)
            end

            #
            # Public Art extension fields
            #
            xml.send(
              'ns2:collectionobjects_publicart',
              'xmlns:ns2' => 'http://collectionspace.org/services/collectionobject/local/publicart',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              map_publicart(xml, attributes)
            end
          end # run(wrapper: "document") do |xml|
        end # def convert

        def map_common(xml, attributes)
          super(xml, attributes.merge(redefined_fields))

          pairs = {
            'computedcurrentlocation' => 'computedCurrentLocation'
          }
          pairs_transforms = {
            'computedcurrentlocation' => { 'authority' => %w[locationauthorities indeterminate] }
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
          repeats = {
            'responsibledepartment' => %w[responsibleDepartments responsibleDepartment],
            'contentconcept' => %w[contentConcepts contentConcept],
            'contentpersonlocal' => %w[contentPersons contentPerson],
            'contentpersonshared' => %w[contentPersons contentPerson],
            'contentorganizationlocal' => %w[contentOrganizations contentOrganization],
            'contentorganizationshared' => %w[contentOrganizations contentOrganization],
            'ownerpersonlocal' => %w[owners owner],
            'ownerpersonshared' => %w[owners owner],
            'ownerorganizationlocal' => %w[owners owner],
            'ownerorganizationshared' => %w[owners owner]

          }
          repeat_transforms = {
            'responsibledepartment' => { 'vocab' => 'program' },
            'contentconcept' => { 'authority' => %w[conceptauthorities material] },
            'contentpersonlocal' => { 'authority' => %w[personauthorities person] },
            'contentpersonshared' => { 'authority' => %w[personauthorities person_shared] },
            'contentorganizationlocal' => { 'authority' => %w[orgauthorities organization] },
            'contentorganizationshared' => { 'authority' => %w[orgauthorities organization_shared] },
            'ownerpersonlocal' => { 'authority' => %w[personauthorities person] },
            'ownerpersonshared' => { 'authority' => %w[personauthorities person_shared] },
            'ownerorganizationlocal' => { 'authority' => %w[orgauthorities organization] },
            'ownerorganizationshared' => { 'authority' => %w[orgauthorities organization_shared] }

          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)
          # objectNameGroupList, objectNameGroup
          oname_data = {
            'objectname' => 'objectName',
            'objectnamenote' => 'objectNameNote'
          }
          oname_transforms = {
            'objectname' => { 'authority' => %w[conceptauthorities worktype] }
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'objectName',
            oname_data,
            oname_transforms,
            list_suffix: 'List'
          )
          # materialGroupList, materialGroup
          mat_data = {
            'material' => 'material',
            'materialcomponentnote' => 'materialComponentNote'
          }
          mat_transforms = {
            'material' => { 'authority' => %w[conceptauthorities material_ca] }
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'material',
            mat_data,
            mat_transforms
          )
          # textualInscriptionGroupList,textualInscriptionGroup
          textualinscriptiondata = {
            'publicartinscriptioncontent' => 'inscriptionContent',
            'publicartinscriptioncontentinscriberperson' => 'inscriptionContentInscriber',
            'publicartinscriptioncontentinscriberorganizationlocal' => 'inscriptionContentInscriber',
            'publicartinscriptioncontentinscriberorganizationshared' => 'inscriptionContentInscriber',
            'publicartinscriptioncontentlanguage' => 'inscriptionContentLanguage',
            'publicartinscriptioncontentdategroup' => 'inscriptionContentDateGroup',
            'publicartinscriptioncontentposition' => 'inscriptionContentPosition',
            'publicartinscriptioncontentscript' => 'inscriptionContentScript',
            'publicartinscriptioncontenttype' => 'inscriptionContentType',
            'publicartinscriptioncontentmethod' => 'inscriptionContentMethod',
            'publicartinscriptioncontentinterpretation' => 'inscriptionContentInterpretation',
            'publicartinscriptioncontenttranslation' => 'inscriptionContentTranslation',
            'publicartinscriptioncontenttransliteration' => 'inscriptionContentTransliteration'
          }
          textualinscriptiontransforms = {
            'publicartinscriptioncontentinscriberperson' => { 'authority' => %w[personauthorities person] },
            'publicartinscriptioncontentinscriberorganizationlocal' => { 'authority' => %w[orgauthorities organization] },
            'publicartinscriptioncontentinscriberorganizationshared' => { 'authority' => %w[orgauthorities organization_shared] },
            'publicartinscriptioncontentlanguage' => { 'vocab' => 'languages' },
            'publicartinscriptioncontentdategroup' => { 'special' => 'structured_date' }
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'textualInscription',
            textualinscriptiondata,
            textualinscriptiontransforms
          )
          # objectProductionPersonGroupList, objectProductionPersonGroup
          objectprodpersondata = {
            'objectproductionpersonlocal' => 'objectProductionPerson',
            'objectproductionpersonshared' => 'objectProductionPerson',
            'objectproductionpersonrole' => 'objectProductionPersonRole'
          }
          objectprodpersontransforms = {
            'objectproductionpersonlocal' => { 'authority' => %w[personauthorities person] },
            'objectproductionpersonshared' => { 'authority' => %w[personauthorities person_shared] }
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPerson',
            objectprodpersondata,
            objectprodpersontransforms
          )
          # objectProductionOrganizationGroupList, objectProductionOrganizationGroup
          objectprodorgdata = {
            'objectproductionorganizationlocal' => 'objectProductionOrganization',
            'objectproductionorganizationshared' => 'objectProductionOrganization',
            'objectproductionorganizationrole' => 'objectProductionOrganizationRole'
          }
          objectprodorgtransforms = {
            'objectproductionorganizationlocal' => { 'authority' => %w[orgauthorities organization] },
            'objectproductionorganizationshared' => { 'authority' => %w[orgauthorities organization_shared] }
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionOrganization',
            objectprodorgdata,
            objectprodorgtransforms
          )
        end

        def map_publicart(xml, attributes)
          repeats = {
            'publicartcollection' => %w[publicartCollections publicartCollection]
          }
          repeat_transforms = {
            'publicartcollection' => { 'authority' => %w[orgauthorities organization] }
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)
          # publicartProductionDateGroupList, publicartProductionDateGroup
          ppd_data = {
            'publicartproductiondate' => 'publicartProductionDate',
            'publicartproductiondatetype' => 'publicartProductionDateType'
          }
          ppd_transforms = {
            'publicartproductiondate' => { 'special' => 'structured_date' },
            'publicartproductiondatetype' => { 'vocab' => 'proddatetype' }
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'publicartProductionDate',
            ppd_data,
            ppd_transforms
          )
          # publicartProductionPersonGrouplist, publicartProductionPersonGroup
          ppp_data = {
            'publicartproductionpersontype' => 'publicartProductionPersonType',
            'publicartproductionpersonrole' => 'publicartProductionPersonRole',
            'publicartproductionpersonpersonlocal' => 'publicartProductionPerson',
            'publicartproductionpersonpersonshared' => 'publicartProductionPerson',
            'publicartproductionpersonorganizationlocal' => 'publicartProductionPerson',
            'publicartproductionpersonorganizationshared' => 'publicartProductionPerson'
          }
          ppp_transforms = {
            'publicartproductionpersonrole' => { 'vocab' => 'prodpersonrole' },
            'publicartproductionpersonpersonlocal' => { 'authority' => %w[personauthorities person] },
            'publicartproductionpersonorganizationlocal' => { 'authority' => %w[orgauthorities organization] },
            'publicartproductionpersonpersonshared' => { 'authority' => %w[personauthorities person_shared] },
            'publicartproductionpersonorganizationshared' => { 'authority' => %w[orgauthorities organization_shared] }
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'publicartProductionPerson',
            ppp_data,
            ppp_transforms
          )
        end # def self.map
      end # class PublicArtCollectionObject
    end # module PublicArt
  end # module Converter
end # module CollectionSpace
