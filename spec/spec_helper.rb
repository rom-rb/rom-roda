require 'rack/test'

require 'roda'
require 'rom-roda'

require 'sqlite3' unless defined?(RUBY_ENGINE) && RUBY_ENGINE == 'jruby'

require 'rom-sql'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
