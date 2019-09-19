$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'fund_america'
require 'vcr'
require 'support/fabricators_helper.rb'
require 'pry'

RSpec::Matchers.define :be_boolean do
  match do |actual|
    actual == true || actual == false
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.before(:each, :vcr) do |test|
    select_or_create_vcr_cassette(test_name: test.description, full_test_context: self.class.name)
  end
  config.before(:each, :vcr_preserve_exact_body_bytes) do |test|
    select_or_create_vcr_cassette(test_name: test.description, full_test_context: self.class.name,
                                  preserve_exact_body_bytes: true)
  end

  config.after(:each, :vcr) do
    VCR.eject_cassette
  end
  config.after(:each, :vcr_preserve_exact_body_bytes) do
    VCR.eject_cassette
  end
  config.include FabricatorsHelper
end

def select_or_create_vcr_cassette(test_name: ,full_test_context:, **options)
  full_path = full_test_context.gsub('::', '/') + "/#{test_name}"
  full_path.slice!('RSpec/ExampleGroups/')
  VCR.insert_cassette full_path, options
end
