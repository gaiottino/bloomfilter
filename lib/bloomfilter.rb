# encoding: utf-8

require 'java'
require 'ext/java-bloomfilter-0.9.3'

module Jar
  import com.skjegstad.utils.BloomFilter
end

class Bloomfilter
  def initialize(options = {})
    if options[:size] && options[:false_positive_percentage]
      @filter = Jar::BloomFilter.new(options[:false_positive_percentage], options[:size])
    elsif options[:filter]
      @filter = options[:filter]
    else
      raise 'Initialize need either :filter or :size AND :false_positive_percentage'
    end
  end
  
  def << (k)
    @filter.add(k)
  end
  
  def include?(k)
    @filter.contains(k)
  end
  
  def count
    @filter.count
  end
  
  def store(file_path)
    File.open(file_path, 'w') do |file|
      Marshal.dump(@filter, file)
    end
  end
  
  def self.load(file_path)
    File.open(file_path, 'r') do |file|
      return new(:filter => Marshal.load(file))
    end
  end
end