# -*- encoding: utf-8 -*-
# stub: database_cleaner-active_record 1.8.0.beta ruby lib

Gem::Specification.new do |s|
  s.name = "database_cleaner-active_record".freeze
  s.version = "1.8.0.beta"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ernesto Tagwerker".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-01-21"
  s.description = "Strategies for cleaning databases using ActiveRecord. Can be used to ensure a clean state for testing.".freeze
  s.email = ["ernesto@ombulabs.com".freeze]
  s.homepage = "https://github.com/DatabaseCleaner/database_cleaner-active_record".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.7".freeze
  s.summary = "Strategies for cleaning databases using ActiveRecord. Can be used to ensure a clean state for testing.".freeze

  s.installed_by_version = "3.4.7" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<database_cleaner>.freeze, ["~> 1.8.0.beta"])
  s.add_runtime_dependency(%q<activerecord>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.16"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
  s.add_development_dependency(%q<mysql>.freeze, ["~> 2.9.1"])
  s.add_development_dependency(%q<mysql2>.freeze, [">= 0"])
  s.add_development_dependency(%q<activerecord-mysql2-adapter>.freeze, [">= 0"])
  s.add_development_dependency(%q<pg>.freeze, [">= 0"])
  s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
end
