module CollectionSpace
  module Converter
    module Materials
      class MaterialsMaterial < Material
        ::MaterialsMaterial = CollectionSpace::Converter::Materials::MaterialsMaterial
        def convert
          run do |xml|
            MaterialsMaterial.map(xml, attributes)
          end
        end

        def self.map(xml, attributes)
          # materialTerm
          CSXML.add xml, 'shortIdentifier', CSIDF.short_identifier(attributes["termdisplayname"])
          CSXML.add_group_list xml, 'materialTerm', [
            {
              "historicalStatus" => attributes["historicalstatus"],
              "termDisplayName" => attributes["termdisplayname"],
              "termName" => attributes["termname"],
              "termFlag" => CSXML::Helpers.get_vocab('materialtermflag', attributes["termflag"]),
              "termLanguage" => CSXML::Helpers.get_vocab('languages', attributes["termlanguage"]),
              "termPrefForLang" => attributes["termprefforlang"],
              "termQualifier" => attributes["termqualifier"],
              "termSource" => CSXML::Helpers.get_authority('citationauthorities', 'citation', attributes["termsource"]),
              "termSourceID" => attributes["termsourceid"],
              "termSourceDetail" => attributes["termsourcedetail"],
              "termSourceNote" => attributes["termsourcenote"],
              "termStatus" => attributes["termstatus"],
              "termType" => attributes["termtype"],
            }
          ]
          # punlishTo
          overall_publish = []
          publish = CSDR.split_mvf attributes, 'publishto'
          publish.each_with_index do |pb, index|
            overall_publish << {"publishTo" => CSXML::Helpers.get_vocab('publishto', pb)}
          end
          CSXML.add_repeat xml, 'publishTo', overall_publish, 'List'
          # materialComposition
          overall_composition = []
          fname = CSDR.split_mvf attributes, 'materialcompositionfamilyname'
          cname = CSDR.split_mvf attributes, 'materialcompositionclassname'
          gname = CSDR.split_mvf attributes, 'materialcompositiongenericname'
          fname.each_with_index do |famname, index|
            overall_composition << {"materialCompositionFamilyName" => CSXML::Helpers.get_authority('conceptauthorities', 'materialclassification', famname), "materialCompositionClassName" => CSXML::Helpers.get_authority('conceptauthorities', 'materialclassification', cname[index]), "materialCompositionGenericName" => CSXML::Helpers.get_authority('conceptauthorities', 'materialclassification', gname[index])}
          end
          CSXML.add_group_list xml, 'materialComposition', overall_composition
          # description
          CSXML.add xml, 'description', attributes["description"]
          # typicalUse
          overall_use = []
          typical = CSDR.split_mvf attributes, 'typicaluse'
          typical.each_with_index do |tu, index|
            overall_use << {"typicalUse" => CSXML::Helpers.get_vocab('materialuse', tu)}
          end
          CSXML.add_repeat xml, 'typicalUses', overall_use
          # Discontinued
          CSXML.add xml, 'discontinued', attributes["discontinued"]
          CSXML::Helpers.add_organization xml, 'discontinuedBy', attributes["discontinuedby"]
          CSXML.add_repeat xml, 'discontinuedDate', [{
            "dateDisplayDate" => CSDTP.parse(attributes["discontinueddate"]).display_date,
            "dateEarliestScalarValue" => CSDTP.parse(attributes["discontinueddate"]).earliest_scalar,
            "dateLatestScalarValue" => CSDTP.parse(attributes["discontinueddate"]).latest_scalar,
          }] rescue nil
          # Production date
          CSXML.add_repeat xml, 'productionDate', [{
            "dateDisplayDate" => CSDTP.parse(attributes["productiondate"]).display_date,
            "dateEarliestScalarValue" => CSDTP.parse(attributes["productiondate"]).earliest_scalar,
            "dateLatestScalarValue" => CSDTP.parse(attributes["productiondate"]).latest_scalar,
          }]
          # productionNote
          CSXML.add xml, 'productionNote', attributes["productionnote"]
          # materialProductionOrganization
          overall_prod_org = []
          prod_org = CSDR.split_mvf attributes, 'materialproductionorganization'
          prod_role = CSDR.split_mvf attributes, 'materialproductionorganizationrole'
          prod_org.each_with_index do |prdorg, index|
            overall_prod_org << {"materialProductionOrganization" => CSXML::Helpers.get_authority('orgauthorities', 'organization', prdorg), "materialProductionOrganizationRole" => CSXML::Helpers.get_vocab('materialproductionrole', prod_role[index])}
          end
          CSXML.add_group_list xml, 'materialProductionOrganization', overall_prod_org
          # materialProductionPerson
          overall_prod_person = []
          prod_person = CSDR.split_mvf attributes, 'materialproductionperson'
          prod_person_role = CSDR.split_mvf attributes, 'materialproductionpersonrole'
          prod_person.each_with_index do |prdpers, index|
            overall_prod_person << {"materialProductionPerson" => CSXML::Helpers.get_authority('personauthorities', 'person', prdpers), "materialProductionPersonRole" => CSXML::Helpers.get_vocab('materialproductionrole', prod_person_role[index])}
          end
          CSXML.add_group_list xml, 'materialProductionPerson', overall_prod_person
          # materialProductionPlace
          overall_prod_place = []
          prod_place = CSDR.split_mvf attributes, 'materialproductionplace'
          prod_place_role = CSDR.split_mvf attributes, 'materialproductionplacerole'
          prod_place.each_with_index do |prdplc, index|
            overall_prod_place << {"materialProductionPlace" => CSXML::Helpers.get_authority('placeauthorities', 'place', prdplc), "materialProductionPlaceRole" => CSXML::Helpers.get_vocab('materialproductionrole', prod_place_role[index])}
          end
          CSXML.add_group_list xml, 'materialProductionPlace', overall_prod_place
          # featuredApplication
          featured_application = []
          featuredapp = CSDR.split_mvf attributes, 'featuredapplication'
          featuredappnote = CSDR.split_mvf attributes, 'featuredapplicationnote'
          featuredapp.each_with_index do |ftapp, index|
            featured_application << {"featuredApplication" => CSXML::Helpers.get_authority('workauthorities', 'work', ftapp), "featuredApplicationNote" => featuredappnote[index]}
          end
          CSXML.add_group_list xml, 'featuredApplication', featured_application
          # materialCitation
          material_citation = []
          mat_cit = CSDR.split_mvf attributes, 'materialcitationsource'
          mat_cit_detail = CSDR.split_mvf attributes, 'materialcitationsourcedetail'
          mat_cit.each_with_index do |matcit, index|
            material_citation << {"materialCitationSource" => CSXML::Helpers.get_authority('citationauthorities', 'citation', matcit), "materialCitationSourceDetail" => mat_cit_detail[index]}
          end
          CSXML.add_group_list xml, 'materialCitation', material_citation
          # externalUrl
          external_url = []
          ext_url = CSDR.split_mvf attributes, 'externalurl'
          ext_url_note = CSDR.split_mvf attributes, 'externalurlnote'
          ext_url.each_with_index do |exturl, index|
            external_url << {"externalUrl" => exturl, "externalUrlNote" => ext_url_note[index]}
          end 
          CSXML.add_group_list xml, 'externalUrl', external_url
          # additionalResource
          additional_resource = []
          additionalresource = CSDR.split_mvf attributes, 'additionalresource'
          additionalresourcenote = CSDR.split_mvf attributes, 'additionalresourcenote'
          additionalresource.each_with_index do |addres, index|
            additional_resource << {"additionalResource" => CSXML::Helpers.get_vocab('materialresource', addres), "additionalResourceNote" => additionalresourcenote[index]}
          end 
          CSXML.add_group_list xml, 'additionalResource', additional_resource
          # materialTermAttributionContributing
          mta_contributing = []
          mtaco = CSDR.split_mvf attributes, 'materialtermattributioncontributingorganization'
          mtacp = CSDR.split_mvf attributes, 'materialtermattributioncontributingperson'
          mtacd = CSDR.split_mvf attributes, 'materialtermattributioncontributingdate'
          mtaco.each_with_index do |contriborg, index|
            mta_contributing << {"materialTermAttributionContributingOrganization" => CSXML::Helpers.get_authority('orgauthorities', 'organization', contriborg), "materialTermAttributionContributingPerson" => CSXML::Helpers.get_authority('personauthorities', 'person', mtacp[index]), "materialTermAttributionContributingDate" => CSDTP.parse(mtacd[index]).earliest_scalar}
          end 
          CSXML.add_group_list xml, 'materialTermAttributionContributing', mta_contributing
          # materialTermAttributionEditing
          mta_editing = []
          mtaeo = CSDR.split_mvf attributes, 'materialtermattributioneditingorganization'
          mtaep = CSDR.split_mvf attributes, 'materialtermattributioneditingperson'
          mtaed = CSDR.split_mvf attributes, 'materialtermattributioneditingdate'
          mtaen = CSDR.split_mvf attributes, 'materialtermattributioneditingnote'
          mtaeo.each_with_index do |editborg, index|
            mta_editing << {"materialTermAttributionEditingOrganization" => CSXML::Helpers.get_authority('orgauthorities', 'organization', editborg), "materialTermAttributionEditingPerson" => CSXML::Helpers.get_authority('personauthorities', 'person', mtaep[index]), "materialTermAttributionEditingDate" => CSDTP.parse(mtaed[index]).earliest_scalar, "materialTermAttributionEditingNote" => mtaen[index]}
          end 
          CSXML.add_group_list xml, 'materialTermAttributionEditing', mta_editing
          CSXML.add_group_list xml, 'materialTermAttributionContributing', [
            {
              "materialTermAttributionContributingDate" => attributes["material_term_attribution_contributing_date"],
              "materialTermAttributionContributingOrganization" => attributes["material_term_attribution_contributing_organization"],
              "materialTermAttributionContributingPerson" => attributes["material_term_attribution_contributing_person"],
            }
          ]
          # materialTermAttributionEditing
          CSXML.add_group_list xml, 'materialTermAttributionEditing', [
            {
              "materialTermAttributionEditingDate" => attributes["material_term_attribution_editing_date"],
              "materialTermAttributionEditingNote" => attributes["material_term_attribution_editing_note"],
              "materialTermAttributionEditingOrganization" => attributes["material_term_attribution_editing_organization"],
              "materialTermAttributionEditingPerson" => attributes["material_term_attribution_editing_person"],
            }
          ]
          # commonForm
          CSXML.add xml, 'commonForm', CSXML::Helpers.get_vocab('materialform', attributes["commonform"])
          # formType
          overall_form = []
          formtype = CSDR.split_mvf attributes, 'formtype'
          formtype.each_with_index do |ft, index|
            overall_form << {"formType" => CSXML::Helpers.get_vocab('materialformtype', ft)}
          end
          CSXML.add_group_list xml, 'formType', overall_form
          # typicalSize
          #dimensions
          typicalsize = []
          dimensions = []
          dims = split_mvf attributes, 'dimension'
          values = split_mvf attributes, 'value'
          unit = split_mvf attributes["measurementunit"]
          dims.each_with_index do |dim, index|
            dimensions << {"dimension" => dim, "value" => values[index], "measurementUnit" => unit[index]}
          end
          typicalsize << {"typicalSize" => attributes["typicalsize"]}
          CSXML.add_group_list xml, 'typicalSize', typicalsize, 'typicalSizeDimension', dimensions
          # formNote
          CSXML.add xml, 'formNote', attributes["formnote"]
          # acousticalProperty
          acousticproperty = []
          propertytype = CSDR.split_mvf attributes, 'acousticalpropertytype'
          propertynote = CSDR.split_mvf attributes, 'acousticalpropertynote'
          propertytype.each_with_index do |pt, index|
            acousticproperty << {"acousticalPropertyType" => CSXML::Helpers.get_vocab('acousticalproperties', pt), "acousticalPropertyNote" => propertynote[index]}
          end
          CSXML.add_group_list xml, 'acousticalProperty', acousticproperty
          # durabilityProperty
          durabilityproperty = []
          dbpropertytype = CSDR.split_mvf attributes, 'durabilitypropertytype'
          dbpropertynote = CSDR.split_mvf attributes, 'durabilitypropertynote'
          dbpropertytype.each_with_index do |dpt, index|
            durabilityproperty << {"durabilityPropertyType" => CSXML::Helpers.get_vocab('durabilityproperties', dpt), "durabilityPropertyNote" => dbpropertynote[index]}
          end
          CSXML.add_group_list xml, 'durabilityProperty', durabilityproperty
          # electricalProperty
          electricalproperty = []
          epropertytype = CSDR.split_mvf attributes, 'electricalpropertytype'
          epropertynote = CSDR.split_mvf attributes, 'electricalpropertynote'
          epropertytype.each_with_index do |ept, index|
            electricalproperty << {"electricalPropertyType" => CSXML::Helpers.get_vocab('electricalproperties', ept), "electricalPropertyNote" => epropertynote[index]}
          end
          CSXML.add_group_list xml, 'electricalProperty', electricalproperty
          # hygrothermalProperty
          hygrothermalproperty = []
          hypropertytype = CSDR.split_mvf attributes, 'hygrothermalpropertytype'
          hypropertynote = CSDR.split_mvf attributes, 'hygrothermalpropertynote'
          hypropertytype.each_with_index do |hpt, index|
            hygrothermalproperty << {"hygrothermalPropertyType" => CSXML::Helpers.get_vocab('hygrothermalproperties', hpt), "hygrothermalPropertyNote" => hypropertynote[index]}
          end
          CSXML.add_group_list xml, 'hygrothermalProperty', hygrothermalproperty
          # mechanicalProperty
          mechanicalproperty = []
          mcpropertytype = CSDR.split_mvf attributes, 'mechanicalpropertytype'
          mcpropertynote = CSDR.split_mvf attributes, 'mechanicalpropertynote'
          mcpropertytype.each_with_index do |mpt, index|
            mechanicalproperty << {"mechanicalPropertyType" => CSXML::Helpers.get_vocab('mechanicalproperties',  mpt), "mechanicalPropertyNote" => mcpropertynote[index]}
          end 
          CSXML.add_group_list xml, 'mechanicalProperty', mechanicalproperty
          # opticalProperty
          opticalproperty = []
          opropertytype = CSDR.split_mvf attributes, 'opticalpropertytype'
          opropertynote = CSDR.split_mvf attributes, 'opticalpropertynote'
          opropertytype.each_with_index do |opt, index|
            opticalproperty << {"opticalPropertyType" => CSXML::Helpers.get_vocab('opticalproperties', opt), "opticalPropertyNote" => opropertynote[index]}
          end 
          CSXML.add_group_list xml, 'opticalProperty', opticalproperty
          # sensorialProperty
          sensorialproperty = []
          spropertytype = CSDR.split_mvf attributes, 'sensorialpropertytype'
          spropertynote = CSDR.split_mvf attributes, 'sensorialpropertynote'
          spropertytype.each_with_index do |spt, index|
            sensorialproperty << {"sensorialPropertyType" => CSXML::Helpers.get_vocab('sensorialproperties', spt), "sensorialPropertyNote" => spropertynote[index]}
          end 
          CSXML.add_group_list xml, 'sensorialProperty', sensorialproperty
          # smartMaterialProperty
          smartproperty = []
          smartpropertytype = CSDR.split_mvf attributes, 'smartmaterialpropertytype'
          smartpropertynote = CSDR.split_mvf attributes, 'smartmaterialpropertynote'
          smartpropertytype.each_with_index do |smpt, index|
            smartproperty << {"smartMaterialPropertyType" => CSXML::Helpers.get_vocab('smartmaterialproperties', smpt), "smartMaterialPropertyNote" => smartpropertynote[index]}
          end 
          CSXML.add_group_list xml, 'smartMaterialProperty', smartproperty
          # additionalProperty
          additionalproperty = []
          additionalpropertytype = CSDR.split_mvf attributes, 'additionalpropertytype'
          additionalpropertynote = CSDR.split_mvf attributes, 'additionalpropertynote'
          additionalpropertytype.each_with_index do |apt, index|
            additionalproperty << {"additionalPropertyType" => CSXML::Helpers.get_vocab('additionalproperties', apt), "additionalPropertyNote" => additionalpropertynote[index]}
          end
          CSXML.add_group_list xml, 'additionalProperty', additionalproperty
          # propertyNote
          CSXML.add xml, 'propertyNote', attributes["propertynote"]
          # recycledContent
          recycledcontent = []
          rc = CSDR.split_mvf attributes, 'recycledcontent'
          recycledcontenthigh = CSDR.split_mvf attributes, 'recycledcontenthigh'
          recycledcontentqualifier = CSDR.split_mvf attributes, 'recycledcontentqualifier'
          rc.each_with_index do |rct, index|
            recycledcontent << {"recycledContent" => rct, "recycledContentHigh" => recycledcontenthigh[index], "recycledContentQualifier" => recycledcontentqualifier[index]}
          end
          CSXML.add_group_list xml, 'recycledContent', recycledcontent
          # lifecycleComponent
          lifecyclecomponent = []
          lc = CSDR.split_mvf attributes, 'lifecyclecomponent'
          lcnote = CSDR.split_mvf attributes, 'lifecyclecomponentnote'
          lc.each_with_index do |lct, index|
            lifecyclecomponent << {"lifecycleComponent" => CSXML::Helpers.get_vocab('lifecyclecomponents', lct), "lifecycleComponentNote" => lcnote[index]}
          end
          CSXML.add_group_list xml, 'lifecycleComponent', lifecyclecomponent
          # embodiedEnergy
          embodiedenergy = []
          ev = CSDR.split_mvf attributes, 'embodiedenergyvalue'
          evh = CSDR.split_mvf attributes, 'embodiedenergyvaluehigh'
          eu = CSDR.split_mvf attributes, 'embodiedenergyunit'
          en = CSDR.split_mvf attributes, 'embodiedenergynote'
          ev.each_with_index do |energyval, index|
            embodiedenergy << {"embodiedEnergyValue" => energyval, "embodiedEnergyValueHigh" => evh[index], "embodiedEnergyUnit" => CSXML::Helpers.get_vocab('energyunits', eu[index]), "embodiedEnergyNote" => en[index]}
          end
          CSXML.add_group_list xml, 'embodiedEnergy', embodiedenergy
          # certificationCredit
          certificationcredit = []
          cp = CSDR.split_mvf attributes, 'certificationprogram'
          ccn = CSDR.split_mvf attributes, 'certificationcreditnote'
          cp.each_with_index do |cprog, index|
            certificationcredit << {"certificationProgram" => CSXML::Helpers.get_vocab('ecologicalcertifications', cprog), "certificationCreditNote" => ccn[index]}
          end
          CSXML.add_group_list xml, 'certificationCredit', certificationcredit
          # ecologyNote
          CSXML.add xml, 'ecologyNote', attributes["ecologynote"]
          # castingProcess
          castingprocesses = []
          castingprocess = CSDR.split_mvf attributes, 'castingprocess'
          castingprocess.each_with_index do |cp, index|
            castingprocesses << {"castingProcess" => CSXML::Helpers.get_vocab('castingprocesses', cp)}
          end
          CSXML.add_repeat xml, 'castingProcesses', castingprocesses
          # deformingProcess
          deformingprocesses = []
          deformingprocess = CSDR.split_mvf attributes, 'deformingprocess'
          deformingprocess.each_with_index do |dfp, index|
            deformingprocesses << {"deformingProcess" => CSXML::Helpers.get_vocab('deformingprocesses', dfp)}
          end
          CSXML.add_repeat xml, 'deformingProcesses', deformingprocesses
          # joiningProcess
          joiningprocesses = []
          joiningprocess = CSDR.split_mvf attributes, 'joiningprocess'
          joiningprocess.each_with_index do |jp, index|
            joiningprocesses << {"joiningProcess" => CSXML::Helpers.get_vocab('joiningprocesses', jp)}
          end
          CSXML.add_repeat xml, 'joiningProcesses', joiningprocesses
          # machiningProcess
          machiningprocesses = []
          machiningprocess = CSDR.split_mvf attributes, 'machiningprocess'
          machiningprocess.each_with_index do |mcp, index|
            machiningprocesses << {"machiningProcess" => CSXML::Helpers.get_vocab('machiningprocesses', mcp)}
          end
          CSXML.add_repeat xml, 'machiningProcess', machiningprocesses
          # moldingProcess
          moldingprocesses = []
          moldingprocess = CSDR.split_mvf attributes, 'moldingprocess'
          moldingprocess.each_with_index do |mdp, index|
            moldingprocesses << {"moldingProcess" => CSXML::Helpers.get_vocab('moldingprocesses', mdp)}
          end
          CSXML.add_repeat xml, 'moldingProcesses', moldingprocesses
          # rapidPrototypingProcess
          rapidprototypingprocess = []
          rprocess = CSDR.split_mvf attributes, 'rapidprototypingprocess'
          rprocess.each_with_index do |rpp, index|
            rapidprototypingprocess << {"rapidPrototypingProcess" => CSXML::Helpers.get_vocab('rapidprototypingprocesses', rpp)}
          end
          CSXML.add_repeat xml, 'rapidPrototypingProcesses', rapidprototypingprocess
          # surfacingProcess
          surfacingprocesses = []
          surfprocess = CSDR.split_mvf attributes, 'surfacingprocess'
          surfprocess.each_with_index do |surfp, index|
            surfacingprocesses << {"surfacingProcess" => CSXML::Helpers.get_vocab('surfacingprocesses', surfp)}
          end
          CSXML.add_repeat xml, 'surfacingProcesses', surfacingprocesses
          # additionalProcess
          additional = []
          additionalprocess = CSDR.split_mvf attributes, 'additionalprocess'
          additionalprocessnote = CSDR.split_mvf attributes, 'additionalprocessnote'
          additionalprocess.each_with_index do |addp, index|
            additional << {"additionalProcess" => CSXML::Helpers.get_vocab('additionalprocesses', addp), "additionalProcessNote" => additionalprocessnote[index]}
          end
          CSXML.add_group_list xml, 'additionalProcess', additional
          # processNote
          CSXML.add xml, 'processNote', attributes["processnote"]
        end
      end
    end
  end
end
