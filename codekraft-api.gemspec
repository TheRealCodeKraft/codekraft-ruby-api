$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "codekraft/api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "codekraft-api"
  s.version     = Codekraft::Api::VERSION
  s.authors     = ["Arnaud DRAZEK"]
  s.email       = ["adrazek@gmail.com"]
  s.homepage    = "https://github.com/TheRealCodeKraft/codekraft-ruby-api"
  s.summary     = "The Code Base of Codekraft APIs"
  s.description = "Description of Codekraft::Api."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.5"
  s.add_dependency "bcrypt", "~> 3.1.7"
  s.add_dependency "rubyzip"
  s.add_dependency "dotenv"
  s.add_dependency "dotenv-rails"

  s.add_dependency "grape"
  s.add_dependency "grape-active_model_serializers"
  s.add_dependency "hashie-forbidden_attributes"
  s.add_dependency "grape-swagger"
  s.add_dependency "grape-swagger-rails"
  s.add_dependency "grape-swagger-representable"

  #s.add_dependency "paperclip"
  #s.add_dependency "aws-sdk"

  s.add_dependency "resque"
  s.add_dependency "resque-scheduler"

  s.add_dependency "redis"

  s.add_dependency "rack-cors"
  s.add_dependency "doorkeeper"

  s.add_dependency "colorize"

  s.add_dependency "paperclip"
  s.add_dependency "aws-sdk"

  s.add_development_dependency "pg"
end
