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
    
      def store(path, filter)
        tmp = Tempfile.new(TEMP_FILE_PREFIX)
        @file_serializer.store(tmp.path, filter)
        @bucket.put(path, tmp)
      end

      def load(path)
        s3_object = @bucket.get(path)
        tmp = Tempfile.new(TEMP_FILE_PREFIX)
        ::File.open(tmp.path, 'w') do |f|
          f << s3_object.data
        end
        @file_serializer.load(tmp.path)
      end
    end
  end
end