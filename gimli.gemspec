lib = File.expand_path("../lib", __FILE__)
$:.unshift lib unless $:.include? lib

require "gimli/version"

Gem::Specification.new do |s|
  s.name = "gimli"
  s.version = Gimli::Version
  s.authors = "Fredrik Wallgren"
  s.email = "fredrik.wallgren@gmail.com"
  s.homepage = "https://github.com/walle/gimli"
  s.summary = "Utility for converting markup files to pdf files."
  s.description = "Utility for converting markup files to pdf files. Useful for reports etc."

  s.rubyforge_project = s.name

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.textile LICENSE]

  s.add_dependency 'github-markup'
  s.add_dependency 'redcarpet'
  s.add_dependency 'RedCloth'
  s.add_dependency 'org-ruby'
  s.add_dependency 'creole'
  s.add_dependency 'wikicloth'

  s.add_dependency 'albino'
  s.add_dependency 'nokogiri'

  s.add_dependency 'wkhtmltopdf-binary'
  s.add_dependency 'pdfkit'
  s.add_dependency 'optiflag'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'bundler'

  s.files = Dir.glob("{bin,lib,spec,config}/**/*") + ['LICENSE', 'README.textile']
  s.executables = ['gimli']
  s.require_path = ['lib']
end

