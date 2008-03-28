ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'mocha'
require 'test/spec'

# fake the path to obsidian gem
$: << File.join(RAILS_ROOT, "../../lib")
require 'obsidian'
require 'obsidian/rails/model_update_tracker'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
