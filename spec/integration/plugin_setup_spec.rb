require 'spec_helper'

describe ROM::Roda::Plugin do
  context 'memory adapter' do
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

  context 'single sql adapter' do
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
end
