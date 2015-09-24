$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "publish_elf/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "publish_elf"
  s.version     = PublishElf::VERSION
  s.authors     = ["Taras Zubyak"]
  s.email       = ["t.zubyak@gmail.com"]
  s.homepage    = "http://github.com"
  s.summary     = "PublishElf - mountable engine providing basic blog and landing page publishing"
  s.description = "Adds an abitlity to quickly publish blogposts and landing pages for marketing purposes"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.2"
  s.add_dependency 'will_paginate', '>= 3.0'
  s.add_dependency 'acts-as-taggable-on', '>= 3.0'
  s.add_dependency 'sir_trevor_rails'

end
