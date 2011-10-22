$:.push File.dirname(__FILE__) + '/lib'
require 'zomato.rb'

Gem::Specification.new do |gem|
  gem.name = %q{zomato}
  gem.authors = ["Chirantan Rajhans"]
  gem.date = %q{2011-10-22}
  gem.description = %q{Ruby wrapper over Zomato API}
  gem.summary = "Ruby wrapper over Zomato API"
  gem.email = %q{chirantan.rajhans@gmail.com}
  gem.homepage = 'http://www.zomato.com/'

  gem.add_runtime_dependency 'httparty'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ['lib']
  gem.version       = '0.0.1'
end