require 'obsidian/spec'
require 'set'

def Set(*args)
  Set.new(args)
end           

module Obsidian
  module Spec 
    class SubsetMatcher
      include Obsidian::Spec
      def initialize(object) 
        @object = object.to_set
      end  
      def of(*other)
        other = args_to_set(*other)
        assert(@object.proper_subset?(other) || @object==other, "Expected #{@object.inspect} to be a subset of #{other.inspect}")
      end
    end
    class SupersetMatcher
      include Obsidian::Spec
      def initialize(object)
        @object = object.to_set
      end           
      def of(*other)
        other = args_to_set(*other)
        assert(@object.proper_superset?(other) || @object==other, "Expected #{@object.inspect} to be a superset of #{other.inspect}")
      end
    end
  end
end

class Test::Spec::Should
  def subset
    Obsidian::Spec::SubsetMatcher.new(@object)
  end   
  def superset
    Obsidian::Spec::SupersetMatcher.new(@object)
  end
end