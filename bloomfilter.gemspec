# encoding: utf-8

$: << File.expand_path('../lib', __FILE__)

Dir['ext/*.jar'].each { |jar| require jar }

Gem::Specification.new do |s|
  s.name        = 'jruby-bloomfilter'
  s.version     = '1.0.6'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Daniel Gaiottino', 'David Tollmyr']
  s.email       = ['daniel@burtcorp.com', 'david@burtcorp.com']
  s.homepage    = 'http://github.com/gaiottino/bloomfilter'
  s.summary     = %q{JRuby wrapper for java-bloomfilter}
  s.description = %q{JRuby wrapper (+ some extra functionality) to http://code.google.com/p/java-bloomfilter}

  s.rubyforge_project = 'jruby-bloomfilter'
  s.add_dependency 'jets3t-rb'

  s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)
end
