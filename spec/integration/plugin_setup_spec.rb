require 'spec_helper'

describe ROM::Roda::Plugin do
  context 'single adapter' do
    let(:default_repository) do
      class MemoryAdapterExample < Roda
        plugin :rom, :memory
      end

      MemoryAdapterExample.freeze

      ROM.env.repositories[:default]
    end

    it 'configures repository with empty args' do
      expect(default_repository).to be_a(ROM::Memory::Repository)
    end
  end

  context 'single adapter with settings' do
    let(:default_repository) do
      class SqliteAdapterExample < Roda
        plugin :rom, :sql, 'sqlite::memory'
      end

      SqliteAdapterExample.freeze

      ROM.env.repositories[:default]
    end

    it 'configures repository with a connection string' do
      expect(default_repository).to be_a(ROM::SQL::Repository)
    end
  end

  context 'multiple adapters' do
    let(:repositories) do
      class MultipleAdaptersExample < Roda
        plugin :rom, {
          default: [:sql, 'sqlite::memory'],
          warehouse: [:sql, 'sqlite::memory'],
          transient: :memory
        }
      end

      MultipleAdaptersExample.freeze

      ROM.env.repositories
    end

    it 'configures repositories with given settings' do
      expect(repositories[:default]).to be_a(ROM::SQL::Repository)
      expect(repositories[:warehouse]).to be_a(ROM::SQL::Repository)
      expect(repositories[:transient]).to be_a(ROM::Memory::Repository)
    end
  end
end
