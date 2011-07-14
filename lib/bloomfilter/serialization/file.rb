module Bloomfilter
  module Serialization
    class File
      def store(path, filter)
        dir = ::File.dirname(path)
        unless ::File.directory?(dir)
          %x(mkdir -p #{dir})
        end

        unless ::File.directory?(dir)
          $stderr.puts "Unable to create the directory #{dir}. Trying again."
          %x(mkdir -p #{dir})
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
          return Marshal.load(f)
        end
      end
      
    private
    
      def extract_folder_path
      end
    end
  end
end