# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'muppet/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Ismael Celis"]
  gem.email         = ["ismaelct@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""
  
  gem.add_dependency 'thor'
  
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "muppet"
  gem.require_paths = ["lib"]
  gem.version       = Muppet::VERSION
end
