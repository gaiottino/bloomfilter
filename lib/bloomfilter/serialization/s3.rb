require 'jets3t'
require 'tempfile'

module Bloomfilter
  module Serialization
    class S3
      AWS_SECRET_PATH = '~/.awssecret'.freeze
      TEMP_FILE_PREFIX = 'bloomfilter'.freeze
    
      def initialize(s3_service, bucket_name)
        @file_serializer = File.new
        @bucket = s3_service.bucket(bucket_name)
      end
    
      def store_file(path, file_path)
        begin
          file = ::File.new(file_path)
          path.slice!(0) if path[0] == '/'
          @bucket.put(path, file)
        rescue Exception => e
          $stderr.puts "Exception when storing to S3 #{e.message}"
          $stderr.puts e.backtrace
        end
      end
      
      def store(path, filter)
        begin
          data = Marshal.dump(filter).to_java_bytes
          @bucket.put_data(path, data)
        end
      end

      def load(path)
        s3_object = @bucket.get(path)
        return nil if s3_object.nil?
        begin
          @loaded_file = Marshal.load(s3_object.data)
        rescue Exception => e
          nil
        end
      end
    end
  end
end