require 'puppetlabs_spec_helper/module_spec_helper'

require 'rspec-puppet-facts'
include RspecPuppetFacts

require 'rspec/expectations'
require 'yaml'

def match_yaml(expected)
  proc { |content| match(expected) === YAML.load(content) }
end

def missing_param(param)
  /(Must pass #{param}|expects a value for parameter '#{param}')/
end
