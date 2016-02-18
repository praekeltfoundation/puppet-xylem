require 'puppetlabs_spec_helper/module_spec_helper'

require 'rspec-puppet-facts'
include RspecPuppetFacts

require 'rspec/expectations'
require 'yaml'

def match_yaml(expected)
  proc { |content| match(expected) === YAML.load(content) }
end
