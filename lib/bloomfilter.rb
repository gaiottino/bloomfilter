# encoding: utf-8

require 'java'
require 'ext/java-bloomfilter-0.9.3'

require_relative 'bloomfilter/serializer'

module Jar
  import com.skjegstad.utils.BloomFilter
end

module Bloomfilter
  class Bloomfilter
    def initialize(options = {})
      if options[:size] && options[:false_positive_percentage]
        @filter = Jar::BloomFilter.new(options[:false_positive_percentage], options[:size])
      elsif options[:filter]
        @filter = options[:filter]
      end
    end
  
    def << (k)
      @filter.add(k)
    end
    
    def add_if_absent(k)
      @filter.synchronized do
        @filter.add(k) unless @filter.contains(k)
      end
    end
  
    def include?(k)
      @filter.contains(k)
    end
  
    def count
      @filter.count
    end
    
  end
end