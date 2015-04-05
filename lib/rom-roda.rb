require 'rom'
require 'rom/roda/version'
require 'rom/roda/plugin'

class Roda
  module RodaPlugins
    register_plugin :rom, ROM::Roda::Plugin
  end
end
