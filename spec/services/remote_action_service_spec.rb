require 'rails_helper'

RSpec.describe RemoteActionService do
  let(:procobject) { prefab_procedure_object }
  let(:procservice) { RemoteActionService.new(procobject) }
  let(:relobject) { prefab_relationship_object }
  let(:relservice) { RemoteActionService.new(relobject) }

  it "has the correct service for procedure object" do
    expect(procservice.service[:id]).to eq('acquisitions')
  end

  it "has the correct service for relations object" do
    expect(relservice.service[:id]).to eq('relations')
  end

  it "has correct list criteria for non-relations service" do
    expect(procservice.list_criteria).to eq(
      ['abstract_common_list', 'list_item']
    )
  end

  it "has correct list criteria for relations service" do
    expect(relservice.list_criteria).to eq(
      ['relations_common_list', 'relation_list_item']
    )
  end
end
