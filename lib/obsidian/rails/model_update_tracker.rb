if defined? RAILS_ENV
  raise "For testing only!" unless RAILS_ENV=="test"  
end
  
module Obsidian::Rails    
  module ModelUpdateTracker
    class Delta
      attr_accessor :committed, :uncommitted
      def initialize
        reset
      end

      def reset
        @committed = []
        @uncommitted = []
      end

      def << (obj)
        @uncommitted << obj
      end

      def transaction_committed
        @committed = @committed + @uncommitted
        @uncommitted = []
      end

      def transaction_rolled_back
        @uncommitted = []
      end

      def instances
        @committed + @uncommitted
      end

      def class_names
        set = instances.inject(Set.new) do |set,inst|
          set << inst.class.to_s
          set
        end
        set
      end
    end
    class << self
      attr_accessor :created_delta, :destroyed_delta, :updated_delta
      def reset
        created_delta.reset
        destroyed_delta.reset
        updated_delta.reset
      end    

      def after_create(model)         
        log("Model create #{model} is a #{model.class}")
        created_delta << model
      end

      def after_update(model)         
        log("Model update #{model}")
        updated_delta << model
      end

      def after_destroy(model)
        log("Model destroy #{model}")
        destroyed_delta << model
      end

      def after_transaction_commit
        log("Commit transaction")
        created_delta.transaction_committed
        updated_delta.transaction_committed
        destroyed_delta.transaction_committed
      end

      def after_transaction_rollback
        log("Rollback of transaction}")
        created_delta.transaction_rolled_back
        updated_delta.transaction_rolled_back
        destroyed_delta.transaction_rolled_back
      end             

      def after_transaction_exception
        log("Exception in transaction}")
        created_delta.transaction_rolled_back
        updated_delta.transaction_rolled_back
        destroyed_delta.transaction_rolled_back
      end             

      def log(msg)
        # puts msg 
      end
    end
    self.created_delta = Delta.new
    self.updated_delta = Delta.new
    self.destroyed_delta = Delta.new
    self.reset     
  end
end

# not using normal after save hooks because of initialization order issues
class ActiveRecord::Base
  def create_with_model_update_tracker(*args,&blk)
    result = create_without_model_update_tracker(*args,&blk)
    Obsidian::Rails::ModelUpdateTracker.after_create(self) if result
    result
  end

  alias_method_chain :create, :model_update_tracker

  def update_with_model_update_tracker(*args,&blk)
    result = update_without_model_update_tracker(*args,&blk)
    Obsidian::Rails::ModelUpdateTracker.after_update(self) if result
    result
  end

  alias_method_chain :update, :model_update_tracker

  def destroy_with_model_destroy_tracker(*args,&blk)
    result = destroy_without_model_destroy_tracker(*args,&blk)
    Obsidian::Rails::ModelUpdateTracker.after_destroy(self) if result
    result
  end

  alias_method_chain :destroy, :model_destroy_tracker
end

class Test::Unit::TestCase       
  def assert_no_models_created(&blk)
    assert_models_created(&blk)
  end

  def assert_no_models_destroyed(&blk)
    assert_models_destroyed(&blk)
  end

  def assert_no_models_updated(&blk)
    assert_models_updated(&blk)
  end

  def assert_models_destroyed(*models, &blk)
    Obsidian::Rails::ModelUpdateTracker.reset
    blk.call
    assert_equal(Set.new(models.map(&:to_s)), Obsidian::Rails::ModelUpdateTracker.destroyed_delta.class_names)
  end

  def assert_models_updated(*models, &blk)
    Obsidian::Rails::ModelUpdateTracker.reset
    blk.call
    assert_equal(Set.new(models.map(&:to_s)), Obsidian::Rails::ModelUpdateTracker.updated_delta.class_names)
  end

  def assert_models_created(*models, &blk)
    Obsidian::Rails::ModelUpdateTracker.reset
    blk.call
    assert_equal(Set.new(models.map(&:to_s)), Obsidian::Rails::ModelUpdateTracker.created_delta.class_names)
  end
end             

module ActiveRecord
  module ConnectionAdapters # :nodoc:
    module DatabaseStatements
      def transaction_with_model_update_tracker(*args,&blk)
        transaction_without_model_update_tracker(*args,&blk)
      rescue
        Obsidian::Rails::ModelUpdateTracker.after_transaction_exception
        raise
      end

      def rollback_db_transaction_with_model_update_tracker
        rollback_db_transaction_without_model_update_tracker
        Obsidian::Rails::ModelUpdateTracker.after_transaction_rollback
      end

      def commit_db_transaction_with_model_update_tracker
        commit_db_transaction_without_model_update_tracker
        Obsidian::Rails::ModelUpdateTracker.after_transaction_commit
      end

      alias_method_chain :transaction, :model_update_tracker
      alias_method_chain :rollback_db_transaction, :model_update_tracker
      alias_method_chain :commit_db_transaction, :model_update_tracker
    end
  end  
end
