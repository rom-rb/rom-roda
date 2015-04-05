source 'https://rubygems.org'

gemspec

gem 'sqlite3', platforms: [:mri, :rbx]

gem 'roda'

platforms :jruby do
  gem 'jdbc-sqlite3'
  gem 'activerecord-jdbc-adapter'
end

group :test do
  gem 'thread_safe'
  gem 'rom', github: 'rom-rb/rom', branch: 'master'
  gem 'rom-sql', github: 'rom-rb/rom-sql', branch: 'master'
  gem 'rspec', '~> 3.2'
  gem 'rack-test'
  gem 'codeclimate-test-reporter', require: nil
end
