lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fund_america/version'

Gem::Specification.new do |spec|
  spec.name          = 'fund_america'
  spec.version       = FundAmerica::VERSION
  spec.authors       = ['Sanjay Vedula']
  spec.email         = ['opensource@rubyeffect.com']

  spec.summary       = 'Ruby gem for easy implementation of FundAmerica API in ruby, rails, sinatra apps'
  spec.description   = 'This is a ruby gem to use the FundAmerica (http://www.fundamerica.com) API easily in your ruby, rails and sinatra apps built by RubyEffect (http://www.rubyeffect.com)'
  spec.homepage      = 'http://blog.rubyeffect.com/category/fundamerica/'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Development Dependencies
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'

  # Runtime Dependencies
  spec.add_runtime_dependency 'base64'
  spec.add_runtime_dependency 'csv'
  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'json'
  # Ruby Dependency
  spec.required_ruby_version = '>= 2.5'
end
