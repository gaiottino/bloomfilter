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
    end
  
    context 'File' do
      it 'should be possible to store a filter to a file' do
        Serializer.file.store(@path, @filter)
        File.new(@path).size.should == 1612
      end

      it 'should be possible to load a filter from a file' do
        filter = Serializer.file.load(@path)
        filter.count.should == 2
        filter.include?('hello').should be_true
        filter.include?('world').should be_true
        filter.include?('bloomfilter').should be_false
      end
    end
  
    context 'S3' do
      before do
        bucket_name = 'test-bucket'
        s3_service = stub('s3_service')
        @bucket = stub(bucket_name)
      
        s3_service.stub(:bucket).with(bucket_name).and_return(@bucket)
        @s3 = Serialization::S3.new(s3_service, bucket_name)
      end
    
      it 'should be possible to store a filter to S3' do
        @bucket.should_receive(:put).with('/some/path', anything)
        @s3.store('/some/path', @filter)
      end
    
      it 'should be possible to load a filter from S3' do
        s3_object = stub('s3_object')
        @bucket.should_receive(:get).with('/some/path').and_return(s3_object)
        s3_object.should_receive(:data).and_return(Marshal.dump(@filter))
        @s3.load('/some/path')
      end
    end
  end
end