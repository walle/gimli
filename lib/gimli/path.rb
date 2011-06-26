# encoding: utf-8

module Gimli

  # Class used to interact with directory structure
  class Path

    # Return an array of paths to valid markup file matching the passed pattern
    # @param [String] target
    # @param [Bool] recursive
    # @return [Array] an array of valid files
    def self.list_valid(target, recursive = false)
      if recursive
        target ||= Dir.pwd
        if File.directory?(target)
          target = File.join(target, '**', '*')
        end
      else
        target ||= Dir.pwd
        if File.directory?(target)
          target = File.join(target, '*')
        end
      end

      # Use select to support ruby 1.8
      Dir.glob(target).select { |file| MarkupFile.new(file).valid? }
    end
  end
end
