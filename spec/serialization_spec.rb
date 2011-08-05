# encoding: utf-8

require_relative 'spec_helper'

require 'tempfile'

module Bloomfilter
  describe 'Serialization' do
    before :all do
      @filter = Bloomfilter.new(:size => 1_000, :false_positive_percentage => 0.01)
      @filter << 'hello'
      @filter << 'world'
      @path = Tempfile.new('bloomfilter').path
      %x(rm -rf /tmp/bloomfilter_spec)
      @path2 = "/tmp/bloomfilter_spec/test1/test2/test3"
    end
  
    context 'File' do
      it 'should be possible to store a filter to a file' do
        Serializer.file.store(@path, @filter)
        File.new(@path).size.should > 0
      end

      it 'should be possible to load a filter from a file' do
        filter = Serializer.file.load(@path)
        filter.count.should == 2
        filter.include?('hello').should be_true
        filter.include?('world').should be_true
        filter.include?('bloomfilter').should be_false
      end

      it 'should create a recursive directory for storing stuff' do
        1000.times do | i |
          filename = @path2 + "/test#{i}/staticdir/filter"
          Serializer.file.store(filename, @filter)
          f = File.new(filename)
          f.size.should > 0
        end
      end

    end
  
    context 'S3 stubbed' do
      before do
        bucket_name = 'test-bucket'
        s3_service = stub('s3_service')
        @bucket = stub(bucket_name)
      
        s3_service.stub(:bucket).with(bucket_name).and_return(@bucket)
        @s3 = Serialization::S3.new(s3_service, bucket_name)
      end
    
      it 'should send serialized file to S3 and strip leading /' do
        @bucket.should_receive(:put_data)
        @s3.store('/some/path', @filter)
      end
    
      it 'should try and get serialized file from S3' do
        s3_object = stub('s3_object')
        @bucket.should_receive(:get).with('/some/path').and_return(s3_object)
        s3_object.should_receive(:data).and_return(Marshal.dump(@filter))
        @s3.load('/some/path')
      end
    end
    
    context 'S3' do
      before do
        aws_secret_path = '~/.awssecret'.freeze
        raise "#{aws_secret_path} not found" unless File.exist?(File.expand_path(aws_secret_path))
        access_key_id, secret_access_key = File.readlines(File.expand_path(aws_secret_path)).map(&:chomp)
        @bucket_name = 'test-bucket-12345'
        credentials = JetS3t::AWSCredentials.new(access_key_id, secret_access_key)
        s3_service = JetS3t::RestS3Service.new(credentials)
        @s3 = Serialization::S3.new(s3_service, @bucket_name)
        @store_path = "/path/rspec_store_test.bin"
        bucket = s3_service.bucket(@bucket_name)
        bucket.delete(@store_path)
      end
    
      it 'should be possible to store and load a filter from S3' do
        @s3.store(@store_path, @filter)
        filter = @s3.load(@store_path)
        filter.include?('hello').should be_true
        filter.include?('world').should be_true
        filter.include?('bloomfilter').should be_false
      end
    end    
  end
end