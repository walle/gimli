require 'optiflag'

# Set up the flags available
module Gimli extend OptiFlagSet
  optional_flag 'file' do
    description 'The file to convert if you do not want to convert all in the current folder'
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
  usage_flag 'h', 'help', '?'

  and_process!
end

