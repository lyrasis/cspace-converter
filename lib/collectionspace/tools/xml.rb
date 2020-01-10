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
      def self.add_group_list(
        xml, key, elements = [], sub_key = false, sub_elements = [],
        list_suffix: 'GroupList',
        group_suffix: 'Group',
        sublist_suffix: 'SubGroupList',
        subgroup_suffix: 'SubGroup',
        include_subgrouplist_level: true
      )
        return unless elements.any?

        # puts "\n\nKEY: #{key}"
        # puts "ELEMENTS:"
        # pp(elements)
        # puts "SUBKEY: #{sub_key}"
        # puts "SUBELEMENTS:"
        # pp(sub_elements)

        xml.send("#{key}#{list_suffix}".to_sym) {
          elements.each_with_index do |element, index|
            xml.send("#{key}#{group_suffix}".to_sym) {
              element.each {|k, v| xml.send(k.to_sym, v)}

              if sub_key && include_subgrouplist_level
                xml.send("#{sub_key}#{sublist_suffix}".to_sym) {
                  sub_elements[index].each do |sub_element|
                    xml.send("#{sub_key}#{subgroup_suffix}".to_sym) {
                      sub_element.each {|k, v| xml.send(k.to_sym, v)}
                    }
                  end
                }
              elsif sub_key && !include_subgrouplist_level
                sub_elements[index].each do |sub_element|
                  xml.send("#{sub_key}#{subgroup_suffix}".to_sym) {
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

      # convenience method to handle pre-processing of non-nested GroupList
      # see add_nested_group_list comments below for info on arguments not explained here
      def self.prep_and_add_single_level_group_list(
        xml,
        attributes,
        key, # String; used to name GroupList
        all_elements,
        transforms = {},
        list_suffix: 'GroupList',
        group_suffix: 'Group'
      )
        all = all_elements.map{ |k, v| [k, {:values => CSDR.split_mvf(attributes, k), :field => v}] }.to_h
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

      # convenience method to build the following structure:
      # topGroupList
      #   topGroup
      #     someDateGroup
      #       structured date fields
      def self.add_group_list_with_structured_date(
        xml,
        attributes,
        topKey,
        all_elements, # { 'csvheader' => 'fieldName' }
        date_field,
        transforms = {},
        list_suffix: 'GroupList',
        group_suffix: 'Group',
        sublist_suffix: '',
        subgroup_suffix: '',
        include_subgrouplist_level: false
      )
        all = all_elements.map{ |k, v| [k, {:values => CSDR.split_mvf(attributes, k), :field => v}] }.to_h
        unless CSXML::Helpers.mvfs_even?(all)
          Rails.logger.warn("Multivalued fields used in #{topKey} Group have uneven numbers of values")
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
        date_groups = []

        groups.each{ |fhash|
          if fhash[date_field]
            date_groups << [CSDTP.fields_for(CSDTP.parse(fhash[date_field]))]
            fhash.delete(date_field)
          end
        }

        CSXML.add_group_list(
          xml, topKey, groups, date_field, date_groups,
          list_suffix: list_suffix, group_suffix: group_suffix,
          sublist_suffix: sublist_suffix, subgroup_suffix: subgroup_suffix,
          include_subgrouplist_level: include_subgrouplist_level
        )
      end #def self.add_group_list_with_structured_date

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
        all = all_elements.map{ |k, v| [k, {:values => CSDR.split_mvf(attributes, k), :field => v}] }.to_h
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
            child_group_splits[field] = {:values => tg[field].split('^^'), :field => field}
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
                value = value.gsub!(r['find'], r['replace'])
              when 'regexp'
                value = value.gsub!(Regexp.new(r['find']), r['replace'])
              end
            }
          end

          if config.keys.include?('special')
            case config['special']
            when 'boolean'
              value = Helpers.to_boolean(value)
            when 'behrensmeyer_translate'
              value = Helpers.behrensmeyer_translate(value)
            when 'unstructured_date'
              value = CSDTP.parse_unstructured_date(value)
            end
          end

          # do not create vocab/authority URNs for blank values
          unless value.empty?
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
            Rails.logger.warn("#{value} cannot be converted to boolean in FIELD/ROW")
            return value
          end
        end

        def self.behrensmeyer_translate(value)
          lookup = {
            '0' => '0 - no cracking or flaking on bone surface',
            '1' => '1 - longitudinal and/or mosaic cracking present on surface',
            '2' => '2 - longitudinal cracks, exfoliation on surface',
            '3' => '3 - fibrous texture, extensive exfoliation',
            '4' => '4 - coarsely fibrous texture, splinters of bone loose on the surface, open cracks',
            '5' => '5 - bone crumbling in situ, large splinters',
            0 => '0 - no cracking or flaking on bone surface',
            1 => '1 - longitudinal and/or mosaic cracking present on surface',
            2 => '2 - longitudinal cracks, exfoliation on surface',
            3 => '3 - fibrous texture, extensive exfoliation',
            4 => '4 - coarsely fibrous texture, splinters of bone loose on the surface, open cracks',
            5 => '5 - bone crumbling in situ, large splinters'
          }
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

        def self.add_date_group(xml, field, date, suffix = 'Group')
          return unless date.display_date

          CSXML.add_group(xml, field, CSDTP.fields_for(date), suffix)
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

        def self.add_pairs(xml, attributes, pairs, transforms={})
          return unless pairs

          pair_values = {}
          pairs.each{ |csvheader, field|
            fieldname = reserved?(field) ? "#{field}_" : field
            value = attributes[csvheader]

            unless transforms.empty?
              value = CSXML::Helpers.apply_transforms(transforms, csvheader, value) if transforms.keys.include?(csvheader)
            end

            pair_values[fieldname] = value
          }

          pair_values.each{ |f, val| CSXML.add(xml, f, val) }
          # pairs.each do |field, attribute|
          #   field = "#{field}_" if reserved?(field)
          #   value 
          #   CSXML.add(xml, field, attributes[attribute])
          # end
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

        def self.add_repeats(xml, attributes, repeats, transforms = {})
          return unless repeats

          repeats.each{ |csvheader, fields|
            values = CSDR.split_mvf(attributes, csvheader)
            unless transforms.empty?
              if transforms.keys.include?(csvheader)
                values = values.map{ |value| CSXML::Helpers.apply_transforms(transforms, csvheader, value) }
              end
            end

            parent = fields[0]
            child = fields[1]

            xml.send(parent.to_sym) {
              values.each{ |value| xml.send(child.to_sym, value)}
              }
            }
        end

        def self.add_simple_repeats(xml, attributes, repeats, key_suffix = '')
          return unless repeats

          repeats.each do |attribute, field|
            values = safe_split(field, attributes, attribute)

            CSXML.add_repeat(xml, field, values, key_suffix)
          end
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
            CSXML.prep_and_add_single_level_group_list(
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
          emptyfields = []
          mvfhash.each{ |k, v| emptyfields << k if v[:values].empty? }
          emptyfields.each{ |field| mvfhash.delete(field) }

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

          fvhash.each{ |k, v| v.reject!{ |e| e.empty? } }

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
