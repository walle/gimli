# encoding: utf-8

require 'optiflag'

# Set up the flags available
module Gimli extend OptiFlagSet
  optional_flag 'file' do
    description 'The file or folder to convert if you do not want to convert all in the current folder'
    alternate_forms 'f'
  end
  optional_flag 'outputdir' do
    description 'The directory to save parsed files if you do not want to use the current folder. The directory is created if it does not exist'
    alternate_forms 'o'
  end
  optional_flag 'stylesheet' do
    description 'The stylesheet to use to override the standard'
    alternate_forms 's'
  end
  optional_flag 'outputfilename' do
    description 'Sets the name of the output file. Only used with single file and in merge mode'
    alternate_forms 'n'
  end
  optional_switch_flag 'recursive' do
    description 'Recurse current or target directory and convert all valid markup files'
    alternate_forms 'r'
  end
  optional_switch_flag 'merge' do
    description 'Merge markup files into single pdf file'
    alternate_forms 'm'
  end
  optional_switch_flag 'version' do
    description 'Show version information and quit'
    alternate_forms 'v'
  end
  usage_flag 'h', 'help', '?'

  and_process!
end

