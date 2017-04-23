# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rename/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name     = 'rename'
  gem.version  = Rename::VERSION
  gem.license  = 'MIT'
  gem.authors  = ['Morshed Alam']
  gem.email    = %w(morshed201@gmail.com)
  gem.homepage = 'https://github.com/morshedalam/rename'
  gem.summary  = 'Rename your Rails application using a single command.'

  gem.add_dependency 'rails', '>= 3.0.0'
  gem.add_dependency 'thor', '>= 0.19.1'
  gem.add_runtime_dependency 'activesupport'
  gem.rubyforge_project = 'rename'

  gem.files         = `git ls-files`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.require_paths = %w(lib)
end
