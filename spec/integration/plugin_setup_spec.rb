require 'spec_helper'

describe ROM::Roda::Plugin do
  SQL_DSN = RUBY_ENGINE == 'jruby' ? 'jdbc:sqlite:memory' : 'sqlite:memory'

  context 'single adapter' do
    let(:default_gateway) do
      class MemoryAdapterExample < Roda
        plugin :rom, {
          default: {
            setup: :memory
          }
        }
      end

      MemoryAdapterExample.freeze

      MemoryAdapterExample.rom.gateways[:default]
    end

    it 'configures gateway with empty args' do
      expect(default_gateway).to be_a(ROM::Memory::Gateway)
    end
  end

  context 'single adapter with settings' do
    let(:default_gateway) do
      class SqliteAdapterExample < Roda
        plugin :rom, {
          default: {
            setup: [:sql, SQL_DSN]
          }
        }
      end

      SqliteAdapterExample.freeze

      SqliteAdapterExample.rom.gateways[:default]
    end

    it 'configures gateway with a connection string' do
      expect(default_gateway).to be_a(ROM::SQL::Gateway)
    end
  end

  context 'multiple adapters' do
    let(:gateways) do
      class MultipleAdaptersExample < Roda
        plugin :rom, {
          default: {
            setup: {
              default: [:sql, SQL_DSN],
              warehouse: [:sql, SQL_DSN],
              transient: :memory
            }
          }
        }
      end

      MultipleAdaptersExample.freeze

      MultipleAdaptersExample.rom.gateways
    end

    it 'configures gateways with given settings' do
      expect(gateways[:default]).to be_a(ROM::SQL::Gateway)
      expect(gateways[:warehouse]).to be_a(ROM::SQL::Gateway)
      expect(gateways[:transient]).to be_a(ROM::Memory::Gateway)
    end
  end

  context 'multiple environments' do
    let(:gateways) do
      class MultipleEnvironmentsExample < Roda
        plugin :rom, {
          memory: {
            setup: :memory
          },
          sql: {
            setup: {
              default: [:sql, SQL_DSN],
              warehouse: [:sql, SQL_DSN],
              transient: :memory
            }
          }
        }
      end

      MultipleEnvironmentsExample.freeze

      {
        memory: MultipleEnvironmentsExample.rom(:memory).gateways,
        sql: MultipleEnvironmentsExample.rom(:sql).gateways
      }
    end

    it 'configures gateways with given settings' do
      expect(gateways[:memory][:default]).to be_a(ROM::Memory::Gateway)
      expect(gateways[:sql][:default]).to be_a(ROM::SQL::Gateway)
      expect(gateways[:sql][:warehouse]).to be_a(ROM::SQL::Gateway)
      expect(gateways[:sql][:transient]).to be_a(ROM::Memory::Gateway)
    end
  end

  context 'with environment plugin settings' do
    let(:relations) do
      class PluginExample < Roda
        plugin :rom, {
          default: {
            setup: :memory,
            plugins: [:auto_registration]
          }
        }
      end

      class Users < ROM::Relation[:memory]
        dataset :users
      end

      PluginExample.freeze

      PluginExample.rom.relations
    end

    it 'configures gateway with a connection string' do
      expect(relations[:users]).to be_a(ROM::Memory::Relation)
    end
  end
end
