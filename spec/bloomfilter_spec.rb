# encoding: utf-8

require_relative 'spec_helper'

require 'tempfile'

module Bloomfilter
  describe Bloomfilter do
    before :all do
      @filter = Bloomfilter.new(:size => 1_000, :false_positive_percentage => 0.01)
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
  end
end