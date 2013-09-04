require File.join([File.dirname(__FILE__),'lib','mc','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'mc'
  s.version = MC::VERSION
  s.author = 'Kale Davis'
  s.email = 'kale@kaledavis.com'
  s.homepage = 'http://rubygems.org/gems/mc'
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.summary = 'mc - the command line interface to MailChimp'
  s.description = 'Access your MailChimp account via the command line using the api. Eep eep!'
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,features}/*`.split("\n")
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables = 'mc'
  s.add_development_dependency('rake')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.7.0')
  s.add_runtime_dependency('gibbon','~> 0.5.0')
  s.add_runtime_dependency('filecache','1.0.0')
end
