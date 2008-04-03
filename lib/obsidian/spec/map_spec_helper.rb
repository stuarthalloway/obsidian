require 'obsidian/spec'

module Obsidian
  module Spec 
    class MappingMatcher
      include Obsidian::Spec
      def initialize(object)
        @object = object.to_set  
      end        
      def map
        self
      end
      def to(*args, &blk)
        case args.size
        when 0 then self
        when 1 then  test("to", args.first, &blk)
        else raise ArgumentError, "wrong number of arguments (#{args.size} for 0-1)"
        end
      end    
      # for be.in
      def set(*other, &blk)
        test("set", *other, &blk)
      end
      def test(method, *other, &blk)
        other = args_to_set(*other)
        @object.each do |obj|
          assert(other.include?(blk.call(obj)), 
                 "Expected #{obj} to map to #{error_message(other)} at\n\t#{read_calling_line(caller,method)}")
        end
      end
      def error_message(set)
        (set.size == 1 ? set.to_a.first : set).inspect
      end
    end
  end
end

class Test::Spec::Should
  def all
    Obsidian::Spec::MappingMatcher.new(@object)
  end   
  def map
    Obsidian::Spec::MappingMatcher.new(@object)
  end   
end