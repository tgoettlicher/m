# -*- encoding: utf-8 -*-
require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "m"
  s.version     = M::VERSION
  s.license     = "GPL-3.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["M M"]
  s.email       = ["m@suse.de"]
  s.homepage    = "https://github.com/SUSE/m/"
  s.summary     = "M"
  s.description = "M"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "m"

  s.add_dependency "cheetah", ">=0.4.0"
  s.add_dependency "json", ">=1.8.0"
  s.add_dependency "json-pointer", ">=0.0.1"
  s.add_dependency "abstract_method", ">=1.2.1"
  s.add_dependency "nokogiri", ">=1.6.0"
  s.add_dependency "gli", "~> 2.11.0"

  s.files        = Dir["lib/**/*.rb", "plugins/**/*.rb", "bin/*", "man/**/*", "NEWS", "COPYING", "helpers/*", "kiwi_helpers/*"]
  s.executables  = "m"
  s.require_path = "lib"

  s.add_development_dependency "ronn", ">=0.7.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "packaging_rake_tasks"
end
