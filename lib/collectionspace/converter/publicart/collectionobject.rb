module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtCollectionObject < CollectionObject
        ::PublicArtCollectionObject = CollectionSpace::Converter::PublicArt::PublicArtCollectionObject
        def redefined_fields
          @redefined.concat([
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
          ])
          super
        end      

        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:collectionobjects_common",
                "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              PublicArtCollectionObject.map_common(xml, attributes, redefined_fields)
            end

            #
            # Public Art extension fields
            #
            xml.send(
              "ns2:collectionobjects_publicart",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/local/publicart",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              # applying namespace breaks import
              xml.parent.namespace = nil
              PublicArtCollectionObject.map_publicart(xml, attributes)
            end
          end #run(wrapper: "document") do |xml|
        end #def convert

        def self.map_common(xml, attributes, redefined)
          CoreCollectionObject.map_common(xml, attributes.merge(redefined))
          pairs = {
            'computedcurrentlocation' => 'computedCurrentLocation',
          }
          pairs_transforms = {
            'computedcurrentlocation' => {'authority' => ['locationauthorities', 'indeterminate']}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pairs_transforms)
          repeats = {
            'responsibledepartment' => ['responsibleDepartments', 'responsibleDepartment'],
            'contentconcept' => ['contentConcepts', 'contentConcept'],
            'contentpersonlocal' => ['contentPersons', 'contentPerson'],
            'contentpersonshared' => ['contentPersons', 'contentPerson'],
            'contentorganizationlocal' => ['contentOrganizations', 'contentOrganization'],
            'contentorganizationshared' => ['contentOrganizations', 'contentOrganization'],
            'ownerpersonlocal' => ['owners', 'owner'],
            'ownerpersonshared' => ['owners', 'owner'],
            'ownerorganizationlocal' => ['owners', 'owner'],
            'ownerorganizationshared' => ['owners', 'owner'],
            
          }
          repeat_transforms = {
            'responsibledepartment' => {'vocab' => 'program'},
            'contentconcept' => {'authority' => ['conceptauthorities', 'material']},
            'contentpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'contentpersonshared' => {'authority' => ['personauthorities', 'person_shared']},
            'contentorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'contentorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']},
            'ownerpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'ownerpersonshared' => {'authority' => ['personauthorities', 'person_shared']},
            'ownerorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'ownerorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']},

          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)
          #objectNameGroupList, objectNameGroup
          oname_data = {
            'objectname' => 'objectName',
            'objectnamenote' => 'objectNameNote'
          }
          oname_transforms = {
            'objectname' => {'authority' => ['conceptauthorities', 'worktype']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'objectName',
            oname_data,
            oname_transforms,
            list_suffix: 'List'
          )
          #materialGroupList, materialGroup
          mat_data = {
            'material' => 'material',
            'materialcomponentnote' => 'materialComponentNote'
          }
          mat_transforms = {
            'material' => {'authority' => ['conceptauthorities', 'material_ca']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'material',
            mat_data,
            mat_transforms
          )
          #textualInscriptionGroupList,textualInscriptionGroup 
          textualinscriptiondata = {
            'inscriptioncontent' => 'inscriptionContent',
            'inscriptioncontentinscriberperson' => 'inscriptionContentInscriber',
            'inscriptioncontentinscriberorganizationlocal' => 'inscriptionContentInscriber',
            'inscriptioncontentinscriberorganizationshared' => 'inscriptionContentInscriber',
            'inscriptioncontentlanguage' => 'inscriptionContentLanguage',
            'inscriptioncontentdategroup' => 'inscriptionContentDateGroup',
            'inscriptioncontentposition' => 'inscriptionContentPosition',
            'inscriptioncontentscript' => 'inscriptionContentScript',
            'inscriptioncontenttype' => 'inscriptionContentType',
            'inscriptioncontentmethod' => 'inscriptionContentMethod',
            'inscriptioncontentinterpretation' => 'inscriptionContentInterpretation',
            'inscriptioncontenttranslation' => 'inscriptionContentTranslation',
            'inscriptioncontenttransliteration' => 'inscriptionContentTransliteration'
          }
          textualinscriptiontransforms = {
            'inscriptioncontentinscriberperson' => {'authority' => ['personauthorities', 'person']},
            'inscriptioncontentinscriberorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'inscriptioncontentinscriberorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']},
            'inscriptioncontentlanguage' => {'vocab' => 'languages'},
            'inscriptioncontentdategroup' => {'special' => 'structured_date'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'textualInscription',
            textualinscriptiondata,
            textualinscriptiontransforms
          )
          #objectProductionPersonGroupList, objectProductionPersonGroup
          objectprodpersondata = {
            'objectproductionpersonlocal' => 'objectProductionPerson',
            'objectproductionpersonshared' => 'objectProductionPerson',
            'objectproductionpersonrole' => 'objectProductionPersonRole'
          }
          objectprodpersontransforms = {
            'objectproductionpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'objectproductionpersonshared' => {'authority' => ['personauthorities', 'person_shared']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionPerson',
            objectprodpersondata,
            objectprodpersontransforms
          )
          #objectProductionOrganizationGroupList, objectProductionOrganizationGroup
          objectprodorgdata = {
            'objectproductionorganizationlocal' => 'objectProductionOrganization',
            'objectproductionorganizationshared' => 'objectProductionOrganization',
            'objectproductionorganizationrole' => 'objectProductionOrganizationRole'
          }
          objectprodorgtransforms = {
            'objectproductionorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'objectproductionorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectProductionOrganization',
            objectprodorgdata,
            objectprodorgtransforms
          )
        end

        def self.map_publicart(xml, attributes)
          repeats = {
            'publicartcollection' => ['publicartCollections', 'publicartCollection']
          }
          repeat_transforms = {
            'publicartcollection' => {'authority' => ['orgauthorities', 'organization']}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)
          #publicartProductionDateGroupList, publicartProductionDateGroup
          ppd_data = {
            'publicartproductiondate' => 'publicartProductionDate',
            'publicartproductiondatetype' => 'publicartProductionDateType'
          }
          ppd_transforms = {
            'publicartproductiondate' => {'special' => 'structured_date'},
            'publicartproductiondatetype' => {'vocab' => 'proddatetype'}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'publicartProductionDate',
            ppd_data,
            ppd_transforms
          )
          #publicartProductionPersonGrouplist, publicartProductionPersonGroup
          ppp_data = {
            'publicartproductionpersontype' => 'publicartProductionPersonType',
            'publicartproductionpersonrole' => 'publicartProductionPersonRole',
            'publicartproductionpersonpersonlocal' => 'publicartProductionPerson',
            'publicartproductionpersonpersonshared' => 'publicartProductionPerson',
            'publicartproductionpersonorganizationlocal' => 'publicartProductionPerson',
            'publicartproductionpersonorganizationshared' => 'publicartProductionPerson',
          }
          ppp_transforms = {
            'publicartproductionpersonrole' => {'vocab' => 'prodpersonrole'},
            'publicartproductionpersonpersonlocal' => {'authority' => ['personauthorities', 'person']},
            'publicartproductionpersonorganizationlocal' => {'authority' => ['orgauthorities', 'organization']},
            'publicartproductionpersonpersonshared' => {'authority' => ['personauthorities', 'person_shared']},
            'publicartproductionpersonorganizationshared' => {'authority' => ['orgauthorities', 'organization_shared']}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'publicartProductionPerson',
            ppp_data,
            ppp_transforms
          )
        end # def self.map
      end # class PublicArtCollectionObject
    end #module PublicArt
  end # module Converter
end # module CollectionSpace
