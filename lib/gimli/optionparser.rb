require 'optparse'
require 'gimli/version'

module Gimli
  class Parser
    def self.parse!(args)
      new.parse!(args)
    end
    
    def parse!(args)
      return {} if args.empty?
      options = {}
      parser(options).parse!(args)
      options
    end
    
    def parser(options)
      OptionParser.new do |parser|
        parser.banner = "Usage: gimli [options] [files or directories]"
        
        parser.on("-o", "--output_dir", "=OUTDIR",
                  "Save parsed files to OUTDIR.  Defaults to working directory.") do |o|
          options[:output_directory] = o
        end
        
        parser.on("-s", "--stylesheet", "=SHEET",
                "Override standard stylesheet with SHEET") do |o|
          options[:stylesheet] = o
        end
        
        parser.on("-r", "--recurse", "--recursive",
                "Recurse current or target directory and convert all valid markup files") do 
          options[:recursive] = true
        end
        
        parser.on("-m", "--merge", "=OUTFILE", 
                "Merge any and all passed markup files into single file of the specified name") do |o|
          options[:merge] = true
          options[:filename] = o
        end
        
        parser.on("-v", "--version", "Show version information and quit") do
          puts Version
          exit
        end
        
        parser.on("-?", "-h", "--help", "Show this message") do 
          puts parser
          exit
        end
      end
    end
  end
end

