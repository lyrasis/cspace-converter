require 'rails_helper'

RSpec.describe AuthCache do
  # TODO: delete
  # let(:cache_object_authority) {
  #   build(
  #     :cache_object,
  #   )
  # }

  # let(:cache_object_vocabulary) {
  #   build(
  #     :cache_object,
  #     refname: "urn:cspace:core.collectionspace.org:vocabularies:name(languages):item:name(eng)'English'",
  #     name: 'English',
  #     identifier: 'eng'
  #   )
  # }

  before(:all) do
    $collectionspace_cache.put(
      'orgauthorities', 'organization', 'Barnes Foundation',
      "urn:cspace:core.collectionspace.org:orgauthorities:name(organization):item:name(BarnesFoundation1542642516661)'Barnes Foundation'"
    )
    $collectionspace_cache.put(
      'vocabularies', 'languages', 'English',
      "urn:cspace:core.collectionspace.org:vocabularies:name(languages):item:name(eng)'English'"
    )
  end

  after(:all) do
    sleep 1
    $collectionspace_cache.clean
  end

  it "can load and retrieve cache objects" do
    # cache_object_authority.save
    expect(
      AuthCache.authority('orgauthorities', 'organization', 'Barnes Foundation')
    ).to eq 'BarnesFoundation1542642516661'
  end

  it "can add to and retrieve vocabularies from the cache" do
    # cache_object_vocabulary.save
    expect(
      AuthCache.vocabulary('languages', 'English')
    ).to eq 'eng'
  end
end
