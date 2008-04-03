require File.join(File.dirname(__FILE__), "../../..", "test_helper.rb")
require 'obsidian/spec/map_spec_helper'
          
describe "to" do
  it "should reject wrong number of arguments" do
    m = Obsidian::Spec::MappingMatcher.new([1])
    lambda{m.to(1,2)}.should.raise(ArgumentError)
  end
end

describe "should.map.to" do

  it "should be able to check agains single values" do 
    [1,2,3].should.all.map.to(true) {|item| item < 10}
  end

  it "should give a great error message" do 
    err = lambda{[1,12,3].should.all.map.to(true) {|item| item < 10}}.should.raise(Test::Unit::AssertionFailedError)
    err.message.should == <<-END.chop
Expected 12 to map to true at
\terr = lambda{[1,12,3].should.all.map.to(true) {|item| item < 10}}.should.raise(Test::Unit::AssertionFailedError).
<false> is not true.
END
  end

end

describe "should.be.in" do

  it "should be able check against multiple values" do 
    [1,2,3].should.map.to.set(2,4,6) {|item| item * 2}
  end

  it "should not care about order" do 
    [1,2,3].should.map.to.set(6,4,2) {|item| item * 2}
  end

  it "should give a great error message" do
    err = lambda{[1,2,3].should.map.to.set(2,4) {|item| item * 2}}.should.raise(Test::Unit::AssertionFailedError)
    err.message.should == <<-END.chop
Expected 3 to map to #<Set: {2, 4}> at
\terr = lambda{[1,2,3].should.map.to.set(2,4) {|item| item * 2}}.should.raise(Test::Unit::AssertionFailedError).
<false> is not true.
END
  end
  
end
