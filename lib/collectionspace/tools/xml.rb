module CollectionSpace
  module Tools
    class XML
      ::CSXML = CollectionSpace::Tools::XML

      def self.add(xml, key, value)
        return unless value

        xml.send(key.to_sym, value)
      end

      def self.add_data(xml, data = [])
        return unless data.any?

        CSXML.process_array(xml, data['label'], data['elements'])
      end

      def self.add_group(xml, key, elements = {})
        return unless elements.any?

        xml.send("#{key}Group".to_sym) {
          elements.each {|k, v| xml.send(k.to_sym, v)}
        }
      end

=begin

IF GROUP IS SINGLE VALUED, you can pass like this:
add_group_list(xml, "objectComponent",
               [{"objectComponentName" => attributes["objectcomponentname"]}]

and it will produce:

 <objectComponentGroupList>
   <objectComponentGroup>
     <objectComponentName>blade</objectComponentName>
   </objectComponentGroup>
 </objectComponentGroupList>

IF GROUP IS MULTIVALUED, the elements argument must be an array of hashes, as follows:

[{'technique' => 'pen and ink', 'techniqueType' => 'type1'},
{'technique' => 'drypoint', 'techniqueType' => 'type1'}]

Called with key = 'technique', this will produce:

  <techniqueGroupList>
    <techniqueGroup>
      <techniqueType>type1</techniqueType>
      <technique>pen and ink</technique>
    </techniqueGroup>
    <techniqueGroup>
      <techniqueType>type1</techniqueType>
      <technique>drypoint</technique>
    </techniqueGroup>
  </techniqueGroupList>

It seems the whole point of group lists is to structure multi-valued information, so
IN GENERAL IT SEEMS LIKE A GOOD IDEA TO USE THE 2ND FORM INSTEAD OF THE 1ST

===SUBGROUPS===
Given a sub_key and sub_elements argument that is an *array of arrays of value hashes*,
this can create multivalued group lists that are children of multivalued group lists, such as...

commingledRemainsGroupList
  commingledRemainsGroup
    mortuaryTreatementGroupList
      mortuaryTreatmentGroup
        mortuaryTreatment
        mortuaryTreatmentNote
      mortuaryTreatmentGroup
        mortuaryTreatment
        mortuaryTreatmentNote
  commingledRemainsGroup
    mortuaryTreatementGroupList
      mortuaryTreatmentGroup
        mortuaryTreatment
        mortuaryTreatmentNote
      mortuaryTreatmentGroup
        mortuaryTreatment
        mortuaryTreatmentNote

Modeling this type of data in the CSV is a bit tricky. For now I have structured the CSV data for
these fields as follows: 

mortuaryTreatment,burned/unburned bone mixture^^embalmed;excarnated^^mummified
mortuaryTreatmentNote,mtnote1^^mtnote2;mtnote3^^mtnote4

The values for each commingledRemainsGroup are separated by ';'
Within each commingledRemainsGroup, the mortuaryTreatmentGroup values are separated by '^^'

For now, the details of how to split up the elements within the subgroup are left in the module
(e.g. anthro > mortuary groups)

***The important thing to note is the sub_elements argument here now requires *an array of arrays of hashes****

The element(s) in the outer/first array = the set of sub_group(s) for each parent group.
The element(s) in the inner array(s) = the individual values for each subgroup
=end
      def self.add_group_list(xml, key, elements = [], sub_key = false, sub_elements = [],
                              include_group_prefix: true,
                              subgroup_list_name_includes_group: true,
                              include_subgroup_prefix: true,
                              include_subgrouplist_level: true
                             )
        return unless elements.any?

        group_prefix = include_group_prefix ? 'GroupList' : 'List'
        subgroup_list_suffix = subgroup_list_name_includes_group ? 'GroupList' : 'List'
        subgroup_prefix = include_subgroup_prefix ? 'Sub' : ''

        xml.send("#{key}#{group_prefix}".to_sym) {
          elements.each_with_index do |element, index|
            xml.send("#{key}Group".to_sym) {
              element.each {|k, v| xml.send(k.to_sym, v)}
              
              if sub_key && include_subgrouplist_level
                xml.send("#{sub_key}#{subgroup_prefix}#{subgroup_list_suffix}".to_sym) {
                  sub_elements[index].each do |sub_element|
                    xml.send("#{sub_key}#{subgroup_prefix}Group".to_sym) {
                      sub_element.each {|k, v| xml.send(k.to_sym, v)}
                    }
                  end
                }
              elsif sub_key && !include_subgrouplist_level
                sub_elements[index].each do |sub_element|
                    xml.send("#{sub_key}#{subgroup_prefix}Group".to_sym) {
                      sub_element.each {|k, v|
                        xml.send(k.to_sym, v)}
                    }
                  end
              elsif sub_elements
                next unless sub_elements[index]

                sub_elements[index].each do |type, sub_element|
                  if sub_element.respond_to? :each
                    xml.send(type.to_sym) {
                      sub_element.each {|k, v| xml.send(k.to_sym, v)}
                    }
                  else
                    xml.send(type, sub_element)
                  end
                end
              end
            }
          end
        }
      end

      # convenience method to handle pre-processing of nested GroupLists and sending them
      #  to add_group_list
      #  vocab_sources hash format is:
      #  { 'fieldName' => { 'vocab' => 'vocabulary name' },
      #    'otherField' => { 'authority' => [authoritytype, authorityname] }
      #  }
      def self.add_nested_group_lists(
        xml,
        attributes,
        topKey, # String; used to name initial GroupList
        all_elements, # { 'fieldName' => 'attributes header' } 
        childKey, # String; used to name the nested GroupList
        child_fields, # ['fieldPartOfChildGroupList', 'anotherChildField']
        vocab_sources = {},
        topGroupList: true, # true: #{topKey}GroupList; false: #{topKey}List
        childGroupList: true, # true: #{childkey}GroupList; false: #{childKey}List
        childListPrefix: true # true: #{childkey}SubGroupList; false: #{childKey}GroupList
      )
        all = all_elements.map{ |k, v| [k, CSDR.split_mvf(attributes, v)] }.to_h
        unless CSDR.mvfs_even?(all)
          Rails.logger.warn("Multivalued fields used in #{topKey} Group have uneven numbers of values")
        end

        top_groups = CSDR.flatten_mvfs(all)
        child_groups = []

        top_groups.each_with_index{ |tg, index|
          child_group_splits = {}
          child_fields.each{ |field|
            child_group_splits[field] = tg[field].split('^^')
            tg.delete(field) if tg[field]
            all.delete(field) if all[field]
          }
          unless CSDR.mvfs_even?(child_group_splits)
            Rails.logger.warn("Multivalued fields used in #{childKey} within #{topKey} (##{index + 1}) have uneven numbers of values")
          end
          child_groups << CSDR.flatten_mvfs(child_group_splits)
        }

        unless vocab_sources.empty?
          Helpers.apply_vocab_sources(vocab_sources, top_groups) if (vocab_sources.keys & all.keys).length > 0
          child_groups.each{ |child_group|
            Helpers.apply_vocab_sources(vocab_sources, child_group)
          } if (vocab_sources.keys & child_fields).length > 0
        end
        
        CSXML.add_group_list(xml, topKey, top_groups, childKey, child_groups,
                             include_group_prefix: topGroupList,
                             subgroup_list_name_includes_group: childGroupList,
                             include_subgroup_prefix: childListPrefix)
      end

      # key_suffix handles the case that the list child element is not the key without "List"
      # for example: key=objectName, list=objectNameList, key_suffix=Group, child=objectNameGroup
      def self.add_list(xml, key, elements = [], key_suffix = '')
        return unless elements.any?

        xml.send("#{key}List".to_sym) {
          elements.each do |element|
            xml.send("#{key}#{key_suffix}".to_sym) {
              element.each {|k, v| xml.send(k.to_sym, v)}
            }
          end
        }
      end

      def self.add_repeat(xml, key, elements = [], key_suffix = '')
        return unless elements.any?

        xml.send("#{key}#{key_suffix}".to_sym) {
          elements.each do |element|
            element.each {|k, v| xml.send(k.to_sym, v)}
          end
        }
      end

      def self.add_string(xml, string)
        return unless string

        xml << string
      end

      def self.process_array(xml, label, array)
        return unless array.any?

        array.each do |hash|
          xml.send(label) do
            hash.each do |key, value|
              if value.is_a?(Array)
                CSXML.process_array(xml, key, value)
              else
                xml.send(key, value)
              end
            end
          end
        end
      end

      module Helpers
       
        def self.apply_vocab_sources(vocab_sources, groups)
          vocab_config = vocab_sources.select{ |k, v| v.keys.first == 'vocab' }
          authority_config = vocab_sources.select{ |k, v| v.keys.first == 'authority' }
          groups.each{ |group|
            group.each{ |field, value|
              if vocab_config.keys.include?(field)
                vocab_name = vocab_config[field]['vocab']
                group[field] = Helpers.get_vocab(vocab_name, value)
              end
              if authority_config.keys.include?(field)
                authority_type = authority_config[field]['authority'][0]
                authority_name = authority_config[field]['authority'][1]
                group[field] = Helpers.get_authority(authority_type, authority_name, value)
              end
            }
          }
        end
        
        def self.add_authority(xml, field, authority_type, authority, value)
          return unless value

          CSXML.add xml, field, CSURN.get_authority_urn(authority_type, authority, value)
        end

        def self.add_authorities(xml, field, authority_type, authority, values = [], method)
          values = values.compact.map do |value|
            {
                field => CSURN.get_authority_urn(authority_type, authority, value),
            }
          end
          return unless values.any?

          field_wrapper = method == :add_repeat ? sketchy_pluralize(field) : field
          CSXML.send(method, xml, field_wrapper, values)
        end

        def self.add_concept(xml, field, value)
          add_authority xml, field, 'conceptauthorities', 'concept', value
        end

        def self.add_concepts(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'conceptauthorities', 'concept', values, method
        end

        def self.add_date_group(xml, field, date)
          return unless date.display_date

          CSXML.add_group xml, field, CSDTP.fields_for(date)
        end

        def self.add_date_group_list(xml, field, dates)
          dates = dates.map { |d| CSDTP.fields_for(d) }.compact
          CSXML.add_group_list xml, field, dates
        end

        def self.add_location(xml, field, value)
          add_authority xml, field, 'locationauthorities', 'location', value
        end

        def self.add_locations(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'locationauthorities', 'location', values, method
        end

        def self.add_material(xml, field, value)
          add_authority xml, field, 'materialauthorities', 'material', value
        end

        def self.add_materials(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'materialauthorities', 'material', values, method
        end

        def self.add_measured_part_group_list(xml, attributes)
          overall_data = {
            "measuredPart" => attributes["measuredpart"],
            "dimensionSummary" => attributes["dimensionsummary"],
          }
          dimensions = []
          dims = CSDR.split_mvf attributes, 'dimension'
          values = CSDR.split_mvf attributes, 'value'
          unit = CSDR.split_mvf attributes, 'measurementunit'
          by = CSXML::Helpers.get_authority(
            'personauthorities', 'person', attributes["measuredby"]
          )
          method = attributes["measurementmethod"]
          date = CSDTP.parse(attributes["valuedate"]).earliest_scalar
          qualifier = attributes["valuequalifier"]
          note = attributes["dimensionnote"]
          dims.each_with_index do |dim, index|
            dimensions << {
              "dimension" => dim,
              "value" => values[index],
              "measurementUnit" => unit[index],
              "measuredBy" => by,
              "measurementMethod" => method,
              "valueDate" => date,
              "valueQualifier" => qualifier,
              "dimensionNote" => note
            }
          end
          CSXML.add_group_list xml, 'measuredPart', [overall_data], 'dimension', [dimensions]
        end

        def self.add_pairs(xml, attributes, pairs)
          return unless pairs

          pairs.each do |attribute, field|
            field = "#{field}_" if reserved?(field)
            CSXML.add(xml, field, attributes[attribute])
          end
        end

        def self.add_person(xml, field, value)
          add_authority xml, field, 'personauthorities', 'person', value
        end

        def self.add_persons(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'personauthorities', 'person', values, method
        end

        def self.add_organization(xml, field, value)
          add_authority xml, field, 'orgauthorities', 'organization', value
        end

        def self.add_organizations(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'orgauthorities', 'organization', values, method
        end

        def self.add_place(xml, field, value)
          add_authority xml, field, 'placeauthorities', 'place', value
        end

        def self.add_places(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'placeauthorities', 'place', values, method
        end

        def self.add_simple_groups(xml, attributes, groups)
          return unless groups

          groups.each do |attribute, field|
            values = safe_split(field, attributes, attribute)
            CSXML.add_group_list xml, field, values
          end
        end

        def self.add_simple_repeats(xml, attributes, repeats, key_suffix = '')
          return unless repeats

          repeats.each do |attribute, field|
            values = safe_split(field, attributes, attribute)
            CSXML.add_repeat xml, field, values, key_suffix
          end
        end

        def self.add_taxon(xml, field, value)
          add_authority xml, field, 'taxonomyauthority', 'taxon', value
        end

        def self.add_title_with_translation(xml, attributes)
          title_data = {
            'title' => 'title',
            'titleLanguage' => 'titlelanguage',
            'titleTranslation' => 'titletranslation',
            'titleTranslationLanguage' => 'titletranslationlanguage'
          }
          title_vocabs = {
            'titleLanguage' => { 'vocab' => 'languages' },
            'titleTranslationLanguage' => { 'vocab' => 'languages' }
          }
          trans_fields = [
            'titleTranslation',
            'titleTranslationLanguage'
            ]

          CSXML.add_nested_group_lists(
            xml, attributes,
            'title',
            title_data,
            'titleTranslation',
            trans_fields,
            title_vocabs,
            topGroupList: true,
            childGroupList: true,
            childListPrefix: true
          )
        end
        

        def self.add_title(xml, attributes)
          if attributes["titletranslation"]
            add_title_with_translation(xml, attributes)
          elsif attributes["titlelanguage"]
            CSXML.add_group_list xml, 'title', [{
              "title" => attributes["title"],
              "titleLanguage" => CSXML::Helpers.get_vocab('languages', attributes["titlelanguage"]),
            }]
          else
            CSXML.add_group_list xml, 'title', [{
              "title" => attributes["title"],
            }]
          end
        end

        def self.add_vocab(xml, field, vocabulary, value)
          return unless value

          CSXML.add xml, field, CSURN.get_vocab_urn(vocabulary, value)
        end

        def self.get_authority(authority_type, authority, value)
          return unless value

          CSURN.get_authority_urn(authority_type, authority, value)
        end

        def self.get_vocab(vocabulary, value)
          return unless value

          CSURN.get_vocab_urn(vocabulary, value)
        end

        # TODO: config
        def self.reserved?(field)
          ['comment', 'format'].include?(field)
        end

        def self.safe_split(field, attributes, attribute)
          subfield = field.singularize
          subfield = "#{subfield}_" if reserved?(subfield)
          CSDR.split_mvf(attributes, attribute).map do |p|
            {
              subfield => p
            }
          end
        end

        def self.shortid_for_auth(type, subtype, value)
          refname = CSXML::Helpers.get_authority(type, subtype, value)
          CSURN.parse(refname)[:identifier] if refname
        end

        def self.shortid_for_vocab(vocabulary, value)
          refname = CSXML::Helpers.get_vocab(vocabulary, value)
          CSURN.parse(refname)[:identifier] if refname
        end

        def self.sketchy_pluralize(field)
          "#{field}s".gsub(/ss$/, 's')
        end
      end
    end
  end
end
