require 'rails_helper'

RSpec.describe CollectionSpace::Converter::Lhmc::LhmcConditionCheck do
  context 'row 2' do
    let(:attributes) { get_attributes('lhmc', 'conditioncheck.csv') }
    let(:lcc) { LhmcConditionCheck.new(Lookup.profile_defaults('conditioncheck').merge(attributes)) }
    let(:doc) { get_doc(lcc) }
    let(:record) { get_fixture('lhmc_conditioncheck_row2.xml') }

    describe 'map_common' do
      p = 'conditionchecks_common'
      context 'fields not included in lhmc' do
        [
          "/document/#{p}/conditionCheckGroupList/conditionCheckGroup/condition",
          "/document/#{p}/conditionCheckGroupList/conditionCheckGroup/conditionDate",
          "/document/#{p}/conditionCheckGroupList/conditionCheckGroup/conditionNote",
        ].each do |xpath|
          context "#{xpath}" do
            it 'is empty' do
              verify_field_is_empty(doc, xpath)
            end
          end
        end
      end
      context 'regular fields' do
        [
          "/document/#{p}/conditionCheckRefNumber"
        ].each do |xpath|
          context xpath.to_s do
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end

            it 'matches sample payload' do
              verify_value_match(doc, record, xpath)
            end
          end
        end
      end
    end

    describe 'map_lhmc' do
      l = 'conditionchecks_lhmc'


      context 'authority/vocab fields' do
        [
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionLHMC",
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionFacetLHMC"
        ].each do |xpath|
          context xpath.to_s do
            let(:urn_vals) { urn_values(doc, xpath) }
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end

            it 'values are URNs' do
              verify_values_are_urns(urn_vals)
            end

            it 'URNs match sample payload' do
              verify_urn_match(urn_vals, record, xpath)
            end
          end
        end
      end
      
      context 'regular fields' do
        [
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionDateLHMC",
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionNoteLHMC",
        ].each do |xpath|
          context xpath.to_s do
            it 'is not empty' do
              verify_field_is_populated(doc, xpath)
            end

            it 'matches sample payload' do
              verify_value_match(doc, record, xpath)
            end
          end
        end
      end
    end
  end

   context 'row 3' do
    let(:attributes) { get_attributes_by_row('lhmc', 'conditioncheck.csv', 3) }
    let(:lcc) { LhmcConditionCheck.new(Lookup.profile_defaults('conditioncheck').merge(attributes)) }
    let(:doc) { get_doc(lcc) }
    let(:record) { get_fixture('lhmc_conditioncheck_row3.xml') }

    describe 'map_lhmc' do
      l = 'conditionchecks_lhmc'


      context 'authority/vocab fields' do
        [
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionLHMC",
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionFacetLHMC"
        ].each do |xpath|
          context xpath.to_s do
            let(:urn_vals) { urn_values(doc, xpath) }
            it 'values are URNs' do
              verify_values_are_urns(urn_vals)
            end

            it 'URNs match sample payload' do
              verify_urn_match(urn_vals, record, xpath)
            end
          end
        end
      end
      
      context 'regular fields' do
        [
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionDateLHMC",
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionNoteLHMC",
        ].each do |xpath|
          context xpath.to_s do
            it 'matches sample payload' do
              verify_value_match(doc, record, xpath)
            end
          end
        end
      end
    end
   end

   context 'row 4' do
    let(:attributes) { get_attributes_by_row('lhmc', 'conditioncheck.csv', 4) }
    let(:lcc) { LhmcConditionCheck.new(Lookup.profile_defaults('conditioncheck').merge(attributes)) }
    let(:doc) { get_doc(lcc) }
    let(:record) { get_fixture('lhmc_conditioncheck_row4.xml') }

    describe 'map_lhmc' do
      l = 'conditionchecks_lhmc'


      context 'authority/vocab fields' do
        [
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionLHMC",
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionFacetLHMC"
        ].each do |xpath|
          context xpath.to_s do
            let(:urn_vals) { urn_values(doc, xpath) }
            it 'values are URNs' do
              verify_values_are_urns(urn_vals)
            end

            it 'URNs match sample payload' do
              verify_urn_match(urn_vals, record, xpath)
            end
          end
        end
      end
      
      context 'regular fields' do
        [
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionDateLHMC",
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionNoteLHMC",
        ].each do |xpath|
          context xpath.to_s do
            it 'matches sample payload' do
              verify_value_match(doc, record, xpath)
            end
          end
        end
      end
    end
   end

   context 'row 5' do
     let(:attributes) { get_attributes_by_row('lhmc', 'conditioncheck.csv', 5) }
     let(:lcc) { LhmcConditionCheck.new(Lookup.profile_defaults('conditioncheck').merge(attributes)) }
     let(:doc) { get_doc(lcc) }
     let(:record) { get_fixture('lhmc_conditioncheck_row5.xml') }

    describe 'map_lhmc' do
      l = 'conditionchecks_lhmc'


      context 'authority/vocab fields' do
        [
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionLHMC",
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionFacetLHMC"
        ].each do |xpath|
          context xpath.to_s do
            let(:urn_vals) { urn_values(doc, xpath) }
            it 'values are URNs' do
              verify_values_are_urns(urn_vals)
            end

            it 'URNs match sample payload' do
              verify_urn_match(urn_vals, record, xpath)
            end
          end
        end
      end
      
      context 'regular fields' do
        [
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionDateLHMC",
          "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionNoteLHMC",
        ].each do |xpath|
          context xpath.to_s do
            it 'matches sample payload' do
              verify_value_match(doc, record, xpath)
            end
          end
        end
      end
    end
   end

   context 'row 6' do
     let(:attributes) { get_attributes_by_row('lhmc', 'conditioncheck.csv', 6) }
     let(:lcc) { LhmcConditionCheck.new(Lookup.profile_defaults('conditioncheck').merge(attributes)) }
     let(:doc) { get_doc(lcc) }
     let(:record) { get_fixture('lhmc_conditioncheck_row6.xml') }

     describe 'map_lhmc' do
       l = 'conditionchecks_lhmc'


       context 'authority/vocab fields' do
         [
           "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionLHMC",
           "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionFacetLHMC"
         ].each do |xpath|
           context xpath.to_s do
             let(:urn_vals) { urn_values(doc, xpath) }
             it 'values are URNs' do
               verify_values_are_urns(urn_vals)
             end

             it 'URNs match sample payload' do
               verify_urn_match(urn_vals, record, xpath)
             end
           end
         end
       end
       
       context 'regular fields' do
         [
           "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionDateLHMC",
           "/document/#{l}/conditionCheckLHMCGroupList/conditionCheckLHMCGroup/conditionNoteLHMC",
         ].each do |xpath|
           context xpath.to_s do
             it 'matches sample payload' do
               verify_value_match(doc, record, xpath)
             end
           end
         end
       end
     end
   end
end
