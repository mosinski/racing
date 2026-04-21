# -*- encoding: utf-8 -*-
# stub: ruby2d 0.12.1 ruby lib
# stub: ext/ruby2d/extconf.rb

Gem::Specification.new do |s|
  s.name = "ruby2d".freeze
  s.version = "0.12.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tom Black".freeze]
  s.date = "2023-01-04"
  s.description = "Make cross-platform 2D applications in Ruby".freeze
  s.email = "tom@blacktm.com".freeze
  s.executables = ["ruby2d".freeze]
  s.extensions = ["ext/ruby2d/extconf.rb".freeze]
  s.files = ["bin/ruby2d".freeze, "ext/ruby2d/extconf.rb".freeze]
  s.homepage = "http://www.ruby2d.com".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0".freeze)
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Ruby 2D".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.12"])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.42"])
end
