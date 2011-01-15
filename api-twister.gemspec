# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "api-twister/version"

Gem::Specification.new do |s|
  s.name        = "api-twister"
  s.version     = Api::Twister::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Scott Jacobsen", "Tee Parham"]
  s.email       = ["hello@stackpilot.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby DSL for non-trivial API specifications}
  s.description = %q{Ruby DSL for non-trivial API specifications}

  s.rubyforge_project = "api-twister"

  s.files         = `git ls-files`.split("\n").delete_if {|file| %w(.rvmrc .gitignore).include? file}
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activesupport", ">= 2.1.0" # for class_inheritable_accessor
  s.add_development_dependency "i18n" #appears to be required by active support
  s.add_development_dependency "test-unit"
  s.add_development_dependency "shoulda"
  s.add_development_dependency "mocha"
end
