# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "simple-graphite"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ian Meyer"]
  s.date = "2013-05-30"
  s.description = "Simple methods for sending data to graphite over TCP or UDP"
  s.email = "ianmmeyer@gmail.com"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["lib/graphite/socket.rb", "lib/simple-graphite.rb", "spec/simple-graphite_spec.rb", "spec/spec_helper.rb", "LICENSE", "README.rdoc"]
  s.homepage = "http://github.com/imeyer/simple-graphite"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Simple hook into graphite"
  s.test_files = ["spec/simple-graphite_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rspec-mocks>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rspec-mocks>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rspec-mocks>, [">= 0"])
  end
end
