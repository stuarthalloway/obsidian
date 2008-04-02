require File.join(File.dirname(__FILE__), "../../..", "test_helper.rb")
require 'obsidian/spec/set_spec_helper'

describe "Set extensions for spec" do
  it "Set acts as a constructor function to approximate a literal syntax for sets" do
    Set(1,2,3).should == Set.new([1,2,3])  
  end
end

describe "should.be.subset.of" do
  it "succeeds for subset" do
    [1,2].should.be.subset.of([1,2,3])
  end
  
  it "succeeds for equal set" do
    (1..3).should.be.subset.of([1,2,3])
  end

  it "will splat args for convenience" do
    (1..3).should.be.subset.of(1,2,3)
  end
  
  it "fails for non-subset" do
    err = lambda{Set(0,5).should.be.subset.of([1,2,3])}.should.raise(Test::Unit::AssertionFailedError)
    err.message.should == "Expected #<Set: {5, 0}> to be a subset of #<Set: {1, 2, 3}>.\n<false> is not true."
  end
end

describe "should.be.superset.of" do
  it "succeeds for superset" do
    [1,2,3].should.be.superset.of([1,2])
  end
  
  it "succeeds for equal set" do
    (1..3).should.be.superset.of([1,2,3])
  end

  it "will splat args for convenience" do
    (1..3).should.be.superset.of(1,2,3)
  end
  
  it "fails for non-superset" do
    err = lambda {Set(1,2).should.be.superset.of([1,2,3])}.should.raise(Test::Unit::AssertionFailedError)
    err.message.should == "Expected #<Set: {1, 2}> to be a superset of #<Set: {1, 2, 3}>.\n<false> is not true."
  end
end
