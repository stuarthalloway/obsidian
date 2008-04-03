require 'test/spec'

module Obsidian
  module Spec     
    include Test::Unit::Assertions
    def args_to_set(*args)
      if args.size == 1
        args.first.respond_to?(:to_set) ? args.first.to_set : Set.new([args.first])
      else
        args.to_set
      end
    end 
    
    # find the line in a stack trace above the one from method_name                     
    def find_calling_line(trace, method_name)
      trace.each_cons(2) do |line, next_line|
        if /(.*):(\d+):in .(.*)'/ =~ line && 
           $3 == method_name &&
           /(.*):(\d+):in .(.*)'/ =~ next_line
          return [$1,$2]
        end
      end
      nil
    end
    
    def read_calling_line(trace, method_name)
      file, line_number = find_calling_line(trace, method_name)
      File.readlines(file)[Integer(line_number) - 1].chop.strip if file
    end   

  end
end