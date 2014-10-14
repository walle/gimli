lib = File.expand_path("../lib", __FILE__)
$:.unshift lib unless $:.include? lib

require "gimli/version"

Gem::Specification.new do |s|
  s.name = "gimli"
  s.version = Gimli::VERSION
  s.authors = "Fredrik Wallgren"
  s.email = "fredrik.wallgren@gmail.com"
  s.homepage = "https://github.com/walle/gimli"
  s.summary = "Utility for converting markup files to pdf files."
  s.description = "Utility for converting markup files to pdf files. Useful for reports etc."

  s.rubyforge_project = s.name

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.textile LICENSE]

  s.add_dependency 'github-markup', '~> 1.3'
  s.add_dependency 'redcarpet', '~> 3.2'
  s.add_dependency 'RedCloth', '~> 4.2.7'

  s.add_dependency 'coderay', '~> 1.1'
  s.add_dependency 'nokogiri', '~> 1.6.3'

  s.add_dependency 'wkhtmltopdf-binary', '~> 0.9.9.3'
  s.add_dependency 'optiflag', '~> 0.7'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'bundler'

  s.files = Dir.glob("{bin,ext,lib,spec,config}/**/*") + ['LICENSE', 'README.textile']
  s.executables = ['gimli']
  s.require_paths = ['lib']
end

