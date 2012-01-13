# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'muppet/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Ismael Celis", "Claudio Ortolina"]
  gem.email         = ["ismaelct@gmail.com"]
  gem.description   = %q{Easy CLI server provisioning using Sprinkle}
  gem.summary       = %q{Easy CLI server provisioning using Sprinkle}
  gem.homepage      = ""

  gem.add_dependency 'thor'
  gem.add_dependency 'sprinkle'
  gem.add_dependency 'i18n' # required by activesupport but not defined in deps?
  gem.add_development_dependency 'rake'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "muppet"
  gem.require_paths = ["lib"]
  gem.version       = Muppet::VERSION
end
