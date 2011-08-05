# encoding: utf-8

require 'java'
require 'ext/java-bloomfilter-0.9.3'

require_relative 'bloomfilter/serializer'
require_relative 'bloomfilter/bucket_group'

module Jar
  import java.util.concurrent.locks.ReentrantLock
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
      
      @lock = Jar::ReentrantLock.new
    end
  
    def << (k)
      lock
      @filter.add(k)
    ensure
      unlock
    end
    
    def include?(k)
      lock
      @filter.contains(k)
    ensure
      unlock
    end
  
    def count
      @filter.count
    end
    
    def lock
      @lock.lock
    end
    
    def unlock
      @lock.unlock
    end
    
  end
end