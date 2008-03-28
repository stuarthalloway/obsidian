basedir = File.dirname(__FILE__)
$:.unshift "#{basedir}/../lib"
require 'rubygems' 
gem 'test-spec'
gem 'activesupport'
gem 'actionpack'
gem 'activerecord'

require 'test/spec'
require 'mocha'    
require 'ostruct'
require 'activerecord'
require 'obsidian'

