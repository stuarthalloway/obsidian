require File.join(File.dirname(__FILE__), "../..", "test_helper.rb")
require 'obsidian/rails/model_update_tracker'
include Obsidian::Rails::ModelUpdateTracker

describe "ModelUpdateTracker" do
  describe "Runtime" do
    xit "Raises an error if anything but test environment is running" 
  end

  describe "Delta" do
    it "adds uncommitted objects with <<" do
      delta = Delta.new
      delta << "Foo"
      delta.uncommitted.should == ["Foo"]
    end     
    
    it "moves uncommitted objects to committed on commit" do
      delta = Delta.new
      delta << "Foo"
      delta.transaction_committed
      delta << "Bar"
      delta.transaction_committed
      delta << "Quux"
      delta.committed.should == ["Foo", "Bar"]
      delta.uncommitted.should == ["Quux"]
    end

    it "moves uncommitted objects to committed on rollback" do
      delta = Delta.new
      delta << "Foo"
      delta.transaction_rolled_back
      delta.committed.should == []
      delta.uncommitted.should == []
    end                             
    
    it "gathers both committed and uncommitted changes into instances" do
      delta = Delta.new
      delta.committed = ["Foo"]
      delta.uncommitted = ["Bar"]
      delta.instances.should == ["Foo", "Bar"]
    end       
    
    it "gathers the class names of modified instances" do
      delta = Delta.new
      delta.committed = ["String"]
      delta.uncommitted = [10]
      delta.class_names.should == Set.new(["Fixnum", "String"])
    end
  end
end
