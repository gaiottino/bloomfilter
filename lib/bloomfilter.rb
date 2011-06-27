# encoding: utf-8

require 'java'
require 'ext/java-bloomfilter-0.9.3'

module Jar
  import com.skjegstad.utils.BloomFilter
end

class Bloomfilter
  def initialize(max_elements, bit_set_size)
    @filter = Jar::BloomFilter.new(bit_set_size, max_elements)
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
end