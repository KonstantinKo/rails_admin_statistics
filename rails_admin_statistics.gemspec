$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_statistics/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_admin_statistics"
  s.version     = RailsAdminStatistics::VERSION
  s.authors     = ["KonstantinKo"]
  #s.email       = ["TODO: Your email"]
  #s.homepage    = "TODO"
  s.summary     = "Simple graphical statistics for Models in rails_admin."
  #s.description = "TODO: Description of RailsAdminStatistics."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"
  s.add_dependency "railties"
  # s.add_dependency "rails_admin"
end
