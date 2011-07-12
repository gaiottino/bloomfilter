require_relative 'serialization/file'
require_relative 'serialization/s3'

module Bloomfilter
  class Serializer

    def self.s3(access_key, secret_key, bucket_name)
      credentials = JetS3t::AWSCredentials.new(access_key_id, secret_access_key)
      s3_service = JetS3t::RestS3Service.new(credentials)
      return Serialization::S3.new(s3_service, bucket_name)
    end
  
    def self.file
      return Serialization::File.new
    end
  
  end
end