require 'rack/test'

require 'roda'
require 'rom-roda'

require 'sqlite3'
require 'rom-sql'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
