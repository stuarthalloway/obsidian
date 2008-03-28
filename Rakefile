# -*- ruby -*-

require 'rubygems'
# require 'hoe'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

# Hoe.new('obsidian', Obsidian::VERSION) do |p|
  # p.rubyforge_name = 'obsidianx' # if different than lowercase project name
#   p.developer('Stuart Halloway', 'stu@thinkrelevance.com')
# end

desc 'Default: run unit tests.'
task :default => :test

desc 'Test obsidian.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

begin
  require 'rcov'
  require "rcov/rcovtask"

  namespace :coverage do
    rcov_output = ENV["CC_BUILD_ARTIFACTS"] || 'tmp/coverage'
    rcov_exclusions = %w{
    }.join(',')
  
    desc "Delete aggregate coverage data."
    task(:clean) { rm_f "rcov_tmp" }
  
    Rcov::RcovTask.new(:unit => :clean) do |t|
      t.test_files = FileList['test/**/*_test.rb']
      t.rcov_opts = ["--sort coverage", "--aggregate 'rcov_tmp'", "--html", "--rails", "--exclude '#{rcov_exclusions}'"]
      t.output_dir = rcov_output + '/unit'
    end
  
    desc "Generate and open coverage report"
    task(:all => [:unit]) do
      system("open #{rcov_output}/unit/index.html") if PLATFORM['darwin']
    end
  end
rescue LoadError
  if RUBY_PLATFORM =~ /java/
    puts 'running in jruby - rcov tasks not available'
  else
    puts 'sudo gem install rcov # if you want the rcov tasks'
  end
end
