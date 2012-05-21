# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dj_mailer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["andrea longhi"]
  gem.email         = ["andrea@spaghetticode.it"]
  gem.description   = %q{send automatically all emails via delayed_job}
  gem.summary       = %q{Allows to send all ActionMailer 3 emails via delayed_job in a transparent way}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'dj_mailer'
  gem.require_paths = ['lib']
  gem.version       = DjMailer::VERSION

  gem.add_dependency 'actionmailer'
  gem.add_dependency 'delayed_job_active_record'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'activerecord'
  gem.add_development_dependency 'guard-cucumber'
end
