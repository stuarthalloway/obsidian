require File.join(File.dirname(__FILE__), "../..", "test_helper.rb")
require 'obsidian/spec'
include Obsidian::Spec

describe "Obsidian::Spec args_to_set" do
  it "can convert a single scalar to a set" do
    args_to_set(:scalar).should == Set.new([:scalar])
  end

  it "can convert a single collection to a set" do
    args_to_set([:a, :b]).should == Set.new([:a, :b])
  end

  it "can convert multiple scalars to a set" do
    args_to_set(:a, :b).should == Set.new([:a, :b])
  end     
end

describe "Obsidian::Spec find_calling_line" do
  def nest_2(name)
    find_calling_line(caller, name)
  end  
  def nest_1(name)
    nest_2(name)
  end  
  it "can parse a stack trace to find the caller of a method" do  
    file, line_no = nest_1("nest_1")   
    file.should.match %r{spec_test.rb$} 
    line_no.should.match /^\d+$/
  end
  it "returns nil if a method does not exist" do  
    file, line_no = nest_1("not_a_real_method_name")
    file.should.be nil
    line_no.should.be nil
  end
end

describe "Obsidian::Spec read_calling_line" do
  def nest_2(name)   
    read_calling_line(caller, name)
  end  
  def nest_1(name)
    nest_2(name)
  end  
  it "can parse a stack trace to find the caller of a method" do  
    nest_1("nest_1").should.match /nest_1\("nest_1"\)/
  end
  it "returns nil if a method does not exist" do  
    nest_1("not_a_real_method_name").should.be nil
  end
end

