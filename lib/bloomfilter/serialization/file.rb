require 'fileutils'

module Bloomfilter
  module Serialization
    class File
      def store(path, filter)
        dir = ::File.dirname(path)
        unless ::File.directory?(dir)
          begin
            FileUtils.mkdir_p(dir)
          rescue => e
            $stderr.puts "Exception raised when trying to create directory: #{path} - #{e.message}"
          end
        end

        unless ::File.directory?(dir)
          $stderr.puts "Unable to create the directory #{dir}. Trying again."
          begin
            FileUtils.mkdir_p(dir)
          rescue => e
            $stderr.puts "Exception raised when trying to create directory: #{path} - #{e.message}"
          end
        end        
        
        unless ::File.directory?(dir)
          $stderr.puts "#{dir} still doesn't exist. Giving up for now."
        else
          ::File.open(path, 'w') do |f|
            Marshal.dump(filter, f)
          end
        end
      end

      def load(path)
        return nil unless ::File.exist?(path)
        
        ::File.open(path, 'r') do |f|
          begin
            @loaded_file = Marshal.load(f) unless f.size == 0
          rescue => e
            @loaded_file = nil
          end
        end
        @loaded_file
      end
      
    private
    
      def extract_folder_path
      end
    end
  end
end