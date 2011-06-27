# encoding: utf-8

require_relative 'spec_helper'

require 'tempfile'

describe Bloomfilter do
  before :all do
    @filter = Bloomfilter.new(:size => 100_000, :false_positive_percentage => 0.01)
    @path = Tempfile.new('bloomfilter').path
  end
  
  it 'should not have any elements from start' do
    @filter.count.should == 0
  end
  
  describe '#<<' do
    it 'should be possible to add elements which updates the count' do
      @filter << 'hello'
      @filter.count.should == 1
    end
  end
  
  describe '#include?' do
    it 'should return false if an element does not exist' do
      @filter.include?('world').should be_false
    end
    
    it 'should return true if an element exists' do
      @filter.include?('hello').should be_true
      
      @filter << 'world'
      @filter.include?('world').should be_true
    end
  end
  
  context 'serialization' do
    before do
      @filter.store(@path)
    end
    
    it 'should be possible to store a filter to a file' do
      File.new(@path).size.should == 126552
    end
    
    it 'should be possible to load a filter from a file' do
      filter = Bloomfilter.load(@path)
      filter.count.should == 2
      filter.include?('hello').should be_true
      filter.include?('world').should be_true
      filter.include?('bloomfilter').should be_false
    end
  end
end