# encoding: utf-8

require 'albino/multi'

# Use Albino Multi
class Gimli::Albino < Albino::Multi
  self.bin = ::Albino::Multi.bin
end

