require 'rake/clean'
require 'rake/testtask'
require 'fileutils'

require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sinatra-formhelpers-ng"
    gem.summary = %Q{Form helpers for Sinatra}
    gem.description = %Q{Simple, lightweight form helpers for Sinatra.}
    gem.email = "cymenvig@gmail.com"
    gem.homepage = "http://github.com/cymen/sinatra-formhelpers"
    gem.authors = ["twilson63", "Nate Wiger", "Cymen Vig"]
    gem.add_development_dependency "bacon", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end


# SPECS ===============================================================

task :test => :spec
desc "run all the specs"
task :spec do
  sh "bacon spec/*_spec.rb"
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'spec'
    test.pattern = 'spec/**/*_spec.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Sinatra::FormHelpers #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end



