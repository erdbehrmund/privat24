# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "privat24/version"

Gem::Specification.new do |s|
  s.name        = "privat24"
  s.version     = Privat24::VERSION
  s.authors     = ["Sergey Sytchewoj"]
  s.email       = ["erdbehrmund@gmail.com"]
  s.homepage    = "https://github.com/erdbehrmund/privat24"
  s.summary     = %q{Privat24 merchant API implementation in Ruby}
  s.description = %q{Privat24 metchant API implementation in Ruby}

  s.add_development_dependency 'rake'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
