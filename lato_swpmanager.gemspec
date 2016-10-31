$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lato_swpmanager"
  s.version     = "0.0.1"
  s.authors     = ["Gregorio Galante"]
  s.email       = ["gregogalante@gmail.com"]
  s.homepage    = "http://www.gregoriogalante.com"
  s.summary     = "Lato module to manage software projects"
  s.description = "Lato module to manage software projects"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib,lang}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"

  # Lato dependencies
  s.add_dependency "lato_view"
  s.add_dependency "lato_core"

end
