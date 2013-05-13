require 'rubygems'
require 'rubygems/package_task'
require 'rake'
require 'rdoc/task'
require 'rspec'
require 'rspec/core/rake_task'

# Use rake to build the gemspec as required
spec = Gem::Specification.new do |s|
  s.name = "simple-graphite"
  s.summary = %q{Simple hook into graphite}
  s.description = %q{Simple methods for sending data to graphite over TCP or UDP}
  s.email = "ianmmeyer@gmail.com"
  s.homepage = "http://github.com/imeyer/simple-graphite"
  s.authors = ["Ian Meyer"]
  s.files = FileList['**/*.rb']
  s.license = "MIT"
  s.version = File.exist?('VERSION') ? File.read('VERSION') : ""

  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]

  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.test_files = [
    "spec/spec_helper.rb",
    "spec/simple-graphite_spec.rb"
  ]

  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-mocks"
  s.test_files = Dir.glob("{spec,test}/**/*.rb")
end
Gem::PackageTask.new(spec).define


# Define the rspec tasks for tests
RSpec::Core::RakeTask.new(:spec)
task :default => :spec


# RCov tasks; ensure code coverage
desc "Run all specs and generate simplecov report"
task :cov do |t|
  ENV['COVERAGE'] = 'true'
  Rake::Task["spec"].execute
  `open coverage/index.html`
end


# Define gemspec to automatically create
# a new 'simple-graphite.gemspec'
def generate_gemspec(spec)
  File.open("#{spec.name}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Generate a new gemspec file"
task :gemspec do
  generate_gemspec spec
end


# Define rdoc tasks
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "simple-graphite #{version}"
  rdoc.rdoc_files.include('README*')
end
