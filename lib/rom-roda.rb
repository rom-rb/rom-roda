require 'rom'
require 'rom/roda/version'
require 'rom/roda/plugin'
require 'roda'

Roda::RodaPlugins.register_plugin(:rom, ROM::Roda::Plugin)
