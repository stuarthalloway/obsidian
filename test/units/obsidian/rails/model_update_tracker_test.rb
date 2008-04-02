require File.join(File.dirname(__FILE__), "../../..", "test_helper.rb")
require 'obsidian/rails/model_update_tracker'
include Obsidian::Rails::ModelUpdateTracker

describe "ModelUpdateTracker" do
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
  
  before do
    @tracker = Obsidian::Rails::ModelUpdateTracker 
    @tracker.reset
  end
  
  it "reset clears all the deltas" do
    @tracker.after_create("Foo")
    @tracker.after_update("Bar")
    @tracker.after_destroy("Quux")
    @tracker.reset
    @tracker.created_delta.instances.should == []
    @tracker.updated_delta.instances.should == []
    @tracker.destroyed_delta.instances.should == []
  end
  
  describe "Data access callbacks" do
    before do
      @tracker = Obsidian::Rails::ModelUpdateTracker 
      @tracker.reset
    end

    it "after_create bumps the created_delta" do
      @tracker.after_create("Foo")
      @tracker.created_delta.instances.should == ["Foo"]
      @tracker.updated_delta.instances.should == []
      @tracker.destroyed_delta.instances.should == []
    end

    it "after_update bumps the updated_delta" do
      @tracker.after_update("Foo")
      @tracker.created_delta.instances.should == []
      @tracker.updated_delta.instances.should == ["Foo"]
      @tracker.destroyed_delta.instances.should == []
    end

    it "after_destroyed bumps the destroyed_delta" do
      @tracker.after_destroy("Foo")
      @tracker.created_delta.instances.should == []
      @tracker.updated_delta.instances.should == []
      @tracker.destroyed_delta.instances.should == ["Foo"]
    end
  end

  describe "Transaction callbacks" do
    before do
      @tracker = Obsidian::Rails::ModelUpdateTracker 
      @tracker.reset
    end

    it "after_transaction_commit commits all the deltas" do
      @tracker.after_create("Foo")
      @tracker.after_update("Bar")
      @tracker.after_destroy("Quux")
      @tracker.after_transaction_commit
      @tracker.created_delta.committed.should == ["Foo"]
      @tracker.updated_delta.committed.should == ["Bar"]
      @tracker.destroyed_delta.committed.should == ["Quux"]
    end

    it "after_transaction_rollback rolls back all the deltas" do
      @tracker.after_create("Foo")
      @tracker.after_update("Bar")
      @tracker.after_destroy("Quux")
      @tracker.after_transaction_rollback
      @tracker.created_delta.instances.should == []
      @tracker.updated_delta.instances.should == []
      @tracker.destroyed_delta.instances.should == []
    end

    it "after_transaction_exception rolls back all the deltas" do
      @tracker.after_create("Foo")
      @tracker.after_update("Bar")
      @tracker.after_destroy("Quux")
      @tracker.after_transaction_exception
      @tracker.created_delta.instances.should == []
      @tracker.updated_delta.instances.should == []
      @tracker.destroyed_delta.instances.should == []
    end
  end
end
