$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "codekraft/api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "codekraft-api"
  s.version     = Codekraft::Api::VERSION
  s.authors     = ["Arnaud DRAZEK"]
  s.email       = ["adrazek@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Codekraft::Api."
  s.description = "TODO: Description of Codekraft::Api."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.5"

  s.add_development_dependency "sqlite3"
end
