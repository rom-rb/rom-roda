require 'spec_helper'

describe ROM::Roda::Plugin do
  SQL_DSN = RUBY_ENGINE == 'jruby' ? 'jdbc:sqlite:memory' : 'sqlite:memory'

  context 'single adapter' do
    let(:default_gateway) do
      class MemoryAdapterExample < Roda
        plugin :rom, :memory
      end

      MemoryAdapterExample.freeze

      ROM.env.gateways[:default]
    end

    it 'configures gateway with empty args' do
      expect(default_gateway).to be_a(ROM::Memory::Gateway)
    end
  end

  context 'single adapter with settings' do
    let(:default_gateway) do
      class SqliteAdapterExample < Roda
        plugin :rom, :sql, SQL_DSN
      end

      SqliteAdapterExample.freeze

      ROM.env.gateways[:default]
    end

    it 'configures gateway with a connection string' do
      expect(default_gateway).to be_a(ROM::SQL::Gateway)
    end
  end

  context 'multiple adapters' do
    let(:gateways) do
      class MultipleAdaptersExample < Roda
        plugin :rom, {
          default: [:sql, SQL_DSN],
          warehouse: [:sql, SQL_DSN],
          transient: :memory
        }
      end

      MultipleAdaptersExample.freeze

      ROM.env.gateways
    end

    it 'configures gateways with given settings' do
      expect(gateways[:default]).to be_a(ROM::SQL::Gateway)
      expect(gateways[:warehouse]).to be_a(ROM::SQL::Gateway)
      expect(gateways[:transient]).to be_a(ROM::Memory::Gateway)
    end
  end
end
