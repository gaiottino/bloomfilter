$:<< 'lib'

require 'benchmark'
require 'bloomfilter'

n = 100_000

Benchmark.bm do |b|
  filter = Bloomfilter.new(100_000, 0.01)
  
  b.report('insert') do
    n.times do |i|
      filter << 'a'
    end
  end

  b.report('lookup present') do
    n.times do
      filter.include?('a')
    end
  end

  b.report('lookup missing') do
    n.times do
      filter.include?('b')
    end
  end
end