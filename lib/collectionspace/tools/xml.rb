module CollectionSpace
  module Tools
    class XML
      ::CSXML = CollectionSpace::Tools::XML

      def self.add(xml, key, value)
        return unless value

        xml.send(key.to_sym, value)
      end

      # this method is not used anywhere 
      # def self.add_data(xml, data = [])
      #   return unless data.any?

      #   CSXML.process_array(xml, data['label'], data['elements'])
      # end

      def self.add_group(xml, key, elements = {}, suffix = 'Group')
        return unless elements.any?

        xml.send("#{key}#{suffix}".to_sym) {
          elements.each {|k, v| xml.send(k.to_sym, v)}
        }
      end

=begin
==GROUPS===
The elements argument should be an array of hashes, as follows:

elements = [{'technique' => 'pen and ink', 'techniqueType' => 'type1'},
            {'technique' => 'drypoint', 'techniqueType' => 'type1'}]

add_group_list(xml, 'technique', elements)

...will produce:

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

***The important thing to note is the sub_elements argument here now requires *an array of arrays of hashes***
Outer array - holds it all together
Inner arrays - hold the value or values for the subgroup for each of the `elements` hashes
Hashes within inner arrays - One per value in subgroup in an element

=end
      def self.add_group_list(
        xml, key, elements = [], sub_key = false, sub_elements = [],
        list_suffix: 'GroupList',
        group_suffix: 'Group',
        sublist_suffix: 'SubGroupList',
        subgroup_suffix: 'SubGroup',
        include_subgrouplist_level: true
      )
        return unless elements.any?

        elements = elements.each{ |group| group.transform_values!{ |v| v == '%NULLVALUE%' ? nil : v } }
        
        #puts "\nELEMENTS FOR KEY: #{key}:"
        #pp(elements)
        #         puts "SUBKEY: #{sub_key}"
        #         puts "SUBELEMENTS:"
        #         pp(sub_elements)

        xml.send("#{key}#{list_suffix}".to_sym) {
          elements.each_with_index do |element, index|
            xml.send("#{key}#{group_suffix}".to_sym) {
              element.each {|k, v|
                if v.is_a?(String)
                  xml.send(k.to_sym, v)
                elsif v.is_a?(Hash)
                  xml.send(k.to_sym) {
                    v.each{ |hk, hv| xml.send(hk.to_sym, hv) }
                    }
                end
              }

              if sub_key && include_subgrouplist_level
                xml.send("#{sub_key}#{sublist_suffix}".to_sym) {
                  unless sub_elements.empty?
                    sub_elements[index].each do |sub_element|
                      xml.send("#{sub_key}#{subgroup_suffix}".to_sym) {
                        sub_element.each {|k, v| xml.send(k.to_sym, v)}
                      }
                    end
                  end
                }
              elsif sub_key && !include_subgrouplist_level
                unless sub_elements.empty?
                  sub_elements[index].each{ |sub_element|
                  xml.send("#{sub_key}#{subgroup_suffix}".to_sym) {
                    sub_element.each {|k, v|
                      xml.send(k.to_sym, v)}
                  }
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

      # convenience method to handle pre-processing of non-nested GroupList
      # see add_nested_group_list comments below for info on arguments not explained here
      def self.add_single_level_group_list(
        xml,
        attributes,
        key, # String; used to name GroupList
        all_elements,
        transforms = {},
        list_suffix: 'GroupList',
        group_suffix: 'Group'
      )
        all = all_elements.map{ |k, v| [k, {:values => CSXML.split_mvf(attributes, k), :field => v}] }.to_h
        unless CSXML::Helpers.mvfs_even?(all)
          Rails.logger.warn("Multivalued fields used in #{key} Group have uneven numbers of values")
        end

        unless transforms.empty?
          transforms.keys.each{ |csvheader|
            if all[csvheader]
              newvals = []
              all[csvheader][:values].each{ |v| newvals << Helpers.apply_transforms(transforms, csvheader, v) }
              all[csvheader][:values] = newvals
            end
          }
        end

        groups = CSXML::Helpers.flatten_mvfs(all)

        CSXML.add_group_list(xml, key, groups, list_suffix: list_suffix, group_suffix: group_suffix)
      end

      # convenience method to handle pre-processing of nested GroupLists and sending them
      #  to add_group_list
      #  transforms hash format is:
      #  { 'fieldName' => { 'vocab' => 'vocabulary name' },
      #    'otherField' => { 'authority' => [authoritytype, authorityname] }
      #  }
      def self.add_nested_group_lists(
        xml,
        attributes,
        topKey, # String; used to name initial GroupList
        all_elements, # { 'csvheader' => 'fieldName' } 
        childKey, # String; used to name the nested GroupList
        child_fields, # ['fieldPartOfChildGroupList', 'anotherChildField']
        transforms = {},
        list_suffix: 'GroupList',
        group_suffix: 'Group',
        sublist_suffix: 'SubGroupList',
        subgroup_suffix: 'SubGroup',
        include_subgrouplist_level: true
      )
        all = all_elements.map{ |k, v| [k, {:values => CSXML.split_mvf(attributes, k), :field => v}] }.to_h
        unless CSXML::Helpers.mvfs_even?(all)
          Rails.logger.warn("Multivalued fields used in #{topKey} Group have uneven numbers of values")
        end

        unless transforms.empty?
          transforms.keys.each{ |csvheader|
            if all[csvheader] && child_fields.include?(all[csvheader][:field])
              newvals = []
              all[csvheader][:values].each{ |vgroup|
                newvgroup = []
                vgroup.split('^^').each{ |v| newvgroup << Helpers.apply_transforms(transforms, csvheader, v) }
                newvals << newvgroup.join('^^')
              }
              all[csvheader][:values] = newvals
            elsif all[csvheader]
              newvals = []
              all[csvheader][:values].each{ |v| newvals << Helpers.apply_transforms(transforms, csvheader, v) }
              all[csvheader][:values] = newvals
            end
          }
        end

        top_groups = CSXML::Helpers.flatten_mvfs(all)
        child_groups = []
        top_groups.each_with_index{ |tg, index|
          child_group_splits = {}
          child_fields.each{ |field|
            child_group_splits[field] = {:values => tg[field].split('^^'), :field => field} if tg[field]
            tg.delete(field) if tg[field]
            all.delete(field) if all[field]
          }
          unless CSXML::Helpers.mvfs_even?(child_group_splits)
            Rails.logger.warn("Multivalued fields used in #{childKey} within #{topKey} (##{index + 1}) have uneven numbers of values")
          end
          child_groups << CSXML::Helpers.flatten_mvfs(child_group_splits)
        }

        CSXML.add_group_list(
          xml, topKey, top_groups, childKey, child_groups,
          list_suffix: list_suffix, group_suffix: group_suffix,
          sublist_suffix: sublist_suffix, subgroup_suffix: subgroup_suffix,
          include_subgrouplist_level: include_subgrouplist_level
        )
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

      # TODO: re-organize when moving to Transformer
      # process multivalued fields by splitting them and returning a flat array of all elements
      def self.split_mvf(attributes, *fields)
        values = []
        fields.each do |field|
          # TODO: log a warning ? may be noisy ...
          next unless attributes.has_key? field
          values << attributes[field]
            .to_s
            .split(Rails.application.config.csv_mvf_delimiter)
            .map(&:strip)
        end
        values.flatten.compact
      end

      module Helpers
        # applies various transformations to field values being prepared for a
        #  FieldGroupList. Handles:
        #   - find/replaces (plain or regexp)
        #   - setting vocab or authority URNs
        #   - special transformations
        # transforms = Hash. Instructions on how to transform fields in the FieldGroup.
        #   for details on the format, see:
        #   https://github.com/collectionspace/cspace-converter/wiki/apply_transforms-method
        # fghash = field group hash: {'csvcolumn' => {:values => [array of split values],
        #                                             :field => CSfield name }
        def self.apply_transforms(transforms, csvheader, value)
          config = transforms[csvheader]

          if config.keys.include?('replace')
            replacements = config['replace']
            replacements.each{ |r|
              case r['type']
              when 'plain'
                value = value.gsub(r['find'], r['replace'])
              when 'regexp'
                value = value.gsub(Regexp.new(r['find']), r['replace'])
              end
            }
          end

          if config.keys.include?('special')
            case config['special']
            when 'boolean'
              value = Helpers.to_boolean(value)
            when 'behrensmeyer_translate'
              value = Helpers.behrensmeyer_translate(value)
            when 'structured_date'
              value = CSDTP.fields_for(CSDTP.parse(value))
            when 'unstructured_date_string'
              value = CSDTP.parse_unstructured_date_string(value)
            when 'unstructured_date_stamp'
              value = CSDTP.parse_unstructured_date_stamp(value)
            when 'upcase_first_char'
              value = value.sub(/^(.)(.*)/){ $1.upcase << $2 }
            when 'downcase_first_char'
              value = value.sub(/^(.)(.*)/){ $1.downcase << $2 }
            end
          end

          # do not create vocab/authority URNs for blank values
          if value.blank?
            value = ''
          else
            if config.keys.include?('vocab')
              vocab = config['vocab']
              value = Helpers.get_vocab(vocab, value)
            end

            if config.keys.include?('authority')
              authority_type = config['authority'][0]
              authority_name = config['authority'][1]
              value = Helpers.get_authority(authority_type, authority_name, value)
            end
          end
          value
        end

        def self.to_boolean(value)
          case value.downcase
          when 'true'
            return 'true'
          when 'false'
            return 'false'
          when ''
            return 'false'
          when 'yes'
            return 'true'
          when 'no'
            return 'false'
          when 'y'
            return 'true'
          when 'n'
            return 'false'
          when 't'
            return 'true'
          when 'f'
            return 'false'
          else
            Rails.logger.warn("#{value} cannot be converted to boolean in FIELD/ROW. Defaulting to false")
            return 'false'
          end
        end

        def self.behrensmeyer_translate(value)
          lookup = {
            0 => '0 - no cracking or flaking on bone surface',
            1 => '1 - longitudinal and/or mosaic cracking present on surface',
            2 => '2 - longitudinal cracks, exfoliation on surface',
            3 => '3 - fibrous texture, extensive exfoliation',
            4 => '4 - coarsely fibrous texture, splinters of bone loose on the surface, open cracks',
            5 => '5 - bone crumbling in situ, large splinters'
          }
          string_keys = lookup.keys.map{ |e| e.to_s }
          value = value.to_i if string_keys.include?(value)
          lookup.fetch(value, value)
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

        # Adds a single value structured date field group at the top level of the document
        # arguments:
        #  xml - the XML document
        #  field - String. The base name of the the date field group
        #  date - CSDTP StructuredDate. Run `CSDTP.parse(value)` on this before passing
        #         it as a parameter
        #  suffix - Optional, will default to 'Group'. String. Added to end of field to create
        #           top-level field name
        # This:
        #  CSXML::Helpers.add_date_group(xml, 'thisDate', '1999-09-09')
        #
        # Will produce:
        #
        # <thisDateGroup>
        #   ...structured date fields for 1999-09-09...
        # </thisDateGroup>
        #
        # This:
        #  CSXML::Helpers.add_date_group(xml, 'thisDate', '1999-09-09', '')
        #
        # Will produce:
        #
        # <thisDate>
        #   ...structured date fields for 1999-09-09...
        # </thisDate>
        def self.add_date_group(xml, field, date, suffix = 'Group')
          return unless date.display_date
          CSXML.add_group(xml, field, CSDTP.fields_for(date), suffix)
        end

        # arguments:
        #  xml - the XML document
        #  field - String. The base name of the date field group list to be created
        #  dates - String. Raw values from the incoming data
        #
        # This:
        #  CSXML::Helpers.add_date_group_list(xml, 'thisDate', '1999-09-09; 2010-12-22')
        #
        # Will produce:
        #
        # <thisDateGroupList>
        #  <thisDateGroup>
        #   ...structured date fields for 1999-09-09...
        #  </thisDateGroup>
        #  <thisDateGroup>
        #   ...structured date fields for 2010-12-22...
        #  </thisDateGroup>
        # </thisDateGroupList>
        def self.add_date_group_list(xml, field, dates)
          dates = CSDH.split_value(dates)
          dates = dates.map{ |d| CSDTP.parse(d) }.compact
          dates = dates.map{ |d| CSDTP.fields_for(d) }
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

        #measuredPartGroupList, measuredPartGroup, dimensionSubGroupList, dimensionSubGroup 
        def self.add_measured_part_group_list(xml, attributes)
           measuredpartdata = {
            'measuredpart' => 'measuredPart',
            'dimensionsummary' => 'dimensionSummary',
            'dimension' => 'dimension',
            'value' => 'value',
            'measurementunit' => 'measurementUnit',
            'measuredby' => 'measuredBy',
            'measuredbyperson' => 'measuredBy',
            'measuredbyorganization' => 'measuredBy',
            'measurementmethod' => 'measurementMethod',
            'valuedate' => 'valueDate',
            'valuequalifier' => 'valueQualifier',
            'dimensionnote' => 'dimensionNote'

          }
          dimensionsdata = [
            'dimension',
            'value',
            'measurementUnit',
            'measuredBy',
            'measurementMethod',
            'valueDate',
            'valueQualifier',
            'dimensionNote'
          ]
          dimensionstransforms = {
            'measuredby' => {'authority' => ['personauthorities', 'person']},
            'measuredbyperson' => {'authority' => ['personauthorities', 'person']},
            'measuredbyorganization' => {'authority' => ['orgauthorities', 'organization']},
            'valuedate' => {'special' => 'unstructured_date_stamp'}
          }
          CSXML.add_nested_group_lists(
            xml, attributes,
            'measuredPart',
            measuredpartdata,
            'dimension',
            dimensionsdata,
            dimensionstransforms
          )

        end

        #typicalSizeGroupList, typicalSizeGroup, typicalSizeDimensionGroupList, typicalSizeDimensionGroup
        def self.add_typical_size_group_list(xml, attributes)
           typicalsizedata = {
            'typicalsize' => 'typicalSize',
            'dimension' => 'dimension',
            'value' => 'value',
            'measurementunit' => 'measurementUnit',

          }
          typicalsizedimensionsdata = [
            'dimension',
            'value',
            'measurementUnit',
          ]
          CSXML.add_nested_group_lists(
            xml, attributes,
            'typicalSize',
            typicalsizedata,
            'typicalSizeDimension',
            typicalsizedimensionsdata,
            sublist_suffix: 'GroupList',
            subgroup_suffix: 'Group'
          )

        end

        def self.add_pairs(xml, attributes, pairs, transforms={})
          return unless pairs

          pair_values = {}
          pairs.each{ |csvheader, field|
            fieldname = reserved?(field) ? "#{field}_" : field
            value = attributes[csvheader]

            unless transforms.empty?
              unless value.nil?
                value = CSXML::Helpers.apply_transforms(transforms, csvheader, value) if transforms.keys.include?(csvheader)
              end
            end

            pair_values[fieldname] = value unless value.nil?
          }

          pair_values.each{ |field_name, value| CSXML.add(xml, field_name, value) }
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

        # Convenience method to handle the addition of fields not themselves part of a field
        #  group, which may have repeated values
        # repeats = Hash. Key = String. Attribute/CSV header value. Value = Array. Element 0
        #   is parent (usually plural or list) field name. Element 1 is child (repeated value)
        #   field name.
        # transforms = Hash. See cspace-converter wiki page on transforms for more details. This
        #   parameter may be omitted if no transforms are required.
        def self.add_repeats(xml, attributes, repeats, transforms = {})
          return unless repeats

          collapsed_repeats = {}

          repeats.each{ |csvheader, fields|
            values = CSXML.split_mvf(attributes, csvheader)
            
            unless transforms.empty?
              if transforms.keys.include?(csvheader)
                values = values.map{ |value| CSXML::Helpers.apply_transforms(transforms, csvheader, value) }
              end
            end

            parent = reserved?(fields[0]) ? "#{fields[0]}_" : fields[0]
            child = reserved?(fields[1]) ? "#{fields[1]}_" : fields[1]
            
            unless collapsed_repeats.has_key?(parent)
              collapsed_repeats[parent] = {'childField' => child, 'values' => []}
            end
            values.each{ |v| collapsed_repeats[parent]['values'] << v }
          }


          collapsed_repeats.each{ |plural, hash|
            xml.send(plural.to_sym) {
              hash['values'].each{ |value|
                xml.send(hash['childField'].to_sym, value)
              }
            }
          }
        end

        def self.add_taxon(xml, field, value)
          add_authority xml, field, 'taxonomyauthority', 'taxon', value
        end

        def self.add_title_with_translation(xml, attributes)
          return unless attributes['title']

          title_data = {
            'title' => 'title'
          }
          title_transforms = {}
          trans_fields = []

          if attributes['titlelanguage']
          title_data['titlelanguage'] = 'titleLanguage'
          title_transforms['titlelanguage'] = { 'vocab' => 'languages' }
          end

          if attributes['titletranslation']
           title_data['titletranslation'] = 'titleTranslation'
           trans_fields << 'titleTranslation'
          end

          if attributes['titletranslationlanguage']
            title_data['titletranslationlanguage'] = 'titleTranslationLanguage'
            title_transforms['titletranslationlanguage'] = { 'vocab' => 'languages' }
            trans_fields << 'titleTranslationLanguage'
          end

          if attributes['titletype']
            title_data['titletype'] = 'titleType'
          end

          CSXML.add_nested_group_lists(
            xml, attributes,
            'title',
            title_data,
            'titleTranslation',
            trans_fields,
            title_transforms,
            list_suffix: 'GroupList',
            sublist_suffix: 'SubGroupList'
          )
        end

        def self.add_title(xml, attributes)
          return unless attributes['title']

          if attributes["titletranslation"]
            add_title_with_translation(xml, attributes)
          else
            title_data = {
              'title' => 'title'
            }
            title_transforms = {}
            if attributes['titlelanguage']
              title_data['titlelanguage'] = 'titleLanguage'
              title_transforms['titlelanguage'] = {'vocab' => 'languages'}
            end
            title_data['titletype'] = 'titleType' if attributes['titleType']
            CSXML.add_single_level_group_list(
              xml, attributes,
              'title',
              title_data,
              title_transforms
              )
          end
        end

        # verifies that the same number of values was derived by splitting all multivalued
        #  fields that will be part of a group.
        # For example, it's potentially problematic if the CSV has name: '1;2' and note: '1;2;3'
        #  if these are mv fields in the same group.
        # This function will return false in that case
        # For the type of hash used as an argument, see crgsplit in anthro/collectionobject.rb
        def self.mvfs_even?(mvfhash)
          lengths = []
          mvfhash.each{ |k, v| lengths << v[:values].length }
          return true if lengths.uniq.length == 1
          return false
        end

        # flattens multivalue group hash (such as crgsplit in anthro/collectionobject.rb
        # returns array of field group hashes
        def self.flatten_mvfs(mvfhash)
          fieldgroups = []
          # remove completely empty fields
          mvfhash.reject!{ |k, v| k if v[:values].empty? }

          return [] if mvfhash.empty?
          
          fvhash = {}
          mvfhash.each{ |csvheader, vhash|
            values = vhash[:values]
            csfield = vhash[:field]
            if fvhash.has_key?(csfield)
              values.each{ |v| fvhash[csfield] << v }
            else
              fvhash[csfield] = values unless fvhash.has_key?(csfield)
            end
          }

          # remove empty values in fields populated by multiple columns
          multicolumn = multicolumn_fields(mvfhash)
          fvhash.each{ |k, v| v.reject!{ |e| e.empty? } if multicolumn.include?(k) }


          # populate a hash with the lengths of all the fields, with one
          #  field name recorded per length value, so we can select one
          #  of the fields with the most values -- doesn't matter which
          lhash = fvhash.map{ |k, v| [v.length, k] }.to_h
          longfieldname = lhash[lhash.keys.max]

          # iterate over field with max number of values
          fvhash[longfieldname].each_index{ |ind|
            fieldgroup = {}
            fvhash.each{ |k, v| fieldgroup[k] = v[ind] }
            fieldgroups << fieldgroup
          }
          return fieldgroups
        end

        # returns list of CS field names where the field gets populated from
        #  more than one csv column
        def self.multicolumn_fields(mvfhash)
          fields = mvfhash.map{ |k, v| v[:field] }
          h = {}
          fields.each{ |f| h.keys.include?(f) ? h[f] += 1 : h[f] = 1 }
          h.select!{ |k, v| k if v > 1}
          return h.keys
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
          CSXML.split_mvf(attributes, attribute).map do |p|
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
