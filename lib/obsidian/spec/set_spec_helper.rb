require 'test/spec'
require 'set'

def Set(*args)
  Set.new(args)
end           

module Obsidian
  module Spec 
    class SubsetMatcher
      include Test::Unit::Assertions
      def initialize(object)
        @object = object.to_set
      end           
      def of(*other)
        other = other.size == 1 ? other[0].to_set : other.to_set
        assert(@object.proper_subset?(other) || @object==other, "Expected #{@object.inspect} to be a subset of #{other.inspect}")
      end
    end
    class SupersetMatcher
      include Test::Unit::Assertions
      def initialize(object)
        @object = object.to_set
      end           
      def of(*other)
        other = other.size == 1 ? other[0].to_set : other.to_set
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