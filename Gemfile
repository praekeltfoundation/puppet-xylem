source 'https://rubygems.org'

group :test do
  if RUBY_VERSION < '2.0'
    # Some things depend on this, and newer versions hate old Ruby.
    gem 'json_pure', '1.8.3'
    gem 'json', '1.8.3'
  end

  gem 'rake'

  puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : '>= 3.4.0'
  gem 'puppet', puppetversion

  gem 'librarian-puppet'
  gem 'metadata-json-lint'
  gem 'puppetlabs_spec_helper'
  gem 'rspec-puppet-facts'
end
