require 'rails_helper'

RSpec.describe CacheObject do
  let(:cache_object) {
    build(
      :cache_object,
    )
  }

  it "can generate a cache object" do
    expect(cache_object).to be_valid
    expect(cache_object.type).to eq 'orgauthorities'
    expect(cache_object.subtype).to eq 'organization'
    expect(cache_object.key).to eq AuthCache.cache_key(
      [cache_object.type, cache_object.subtype, cache_object.name]
    )
  end

  it "can skip list" do
    cache_object.save
    expect(CacheObject.skip_list?(
      cache_object.parent_refname, cache_object.parent_rev
    )).to be true
  end

  it "will not skip list when rev is higher" do
    expect(CacheObject.skip_list?(
      cache_object.parent_refname, cache_object.parent_rev + 1
    )).to be false
  end

  it "has item" do
    expect(CacheObject.item?(cache_object.refname)).to be true
  end
end
