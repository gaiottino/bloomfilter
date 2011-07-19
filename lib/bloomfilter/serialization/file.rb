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
          @loaded_file = Marshal.load(f)
        end
        @loaded_file
      rescue Exception => e
        raise e unless File.new(path).size == 0
      end
      
    private
    
      def extract_folder_path
      end
    end
  end
end