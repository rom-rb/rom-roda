require 'spec_helper'

describe ROM::Roda::Plugin do
  before do
    allow(ROM::Roda::Plugin).to receive(:load_files)
  end

  before do
    Class.new(Roda).plugin :rom, config
  end

  context 'single path' do
    context 'under :load_path as string' do
      let(:config) do
        {
          default: {
            setup: :memory
          },
          load_path: 'models'
        }
      end

      it { expect(ROM::Roda::Plugin).to have_received(:load_files).with(File.expand_path('models')) }
    end

    context 'under :load_path as array' do
      let(:config) do
        {
          default: {
            setup: :memory
          },
          load_path: ['models']
        }
      end

      it { expect(ROM::Roda::Plugin).to have_received(:load_files).with(File.expand_path('models')) }
    end

    context 'under :load_paths as string' do
      let(:config) do
        {
          default: {
            setup: :memory
          },
          load_paths: 'models'
        }
      end

      it { expect(ROM::Roda::Plugin).to have_received(:load_files).with(File.expand_path('models')) }
    end

    context 'under :load_paths as string' do
      let(:config) do
        {
          default: {
            setup: :memory
          },
          load_paths: ['models']
        }
      end

      it { expect(ROM::Roda::Plugin).to have_received(:load_files).with(File.expand_path('models')) }
    end
  end

  context 'multiple paths' do
    context 'under :load_path' do
      let(:config) do
        {
          default: {
            setup: :memory
          },
          load_path: ['api/models', 'web/models']
        }
      end

      it { expect(ROM::Roda::Plugin).to have_received(:load_files).with(File.expand_path('api/models')) }
      it { expect(ROM::Roda::Plugin).to have_received(:load_files).with(File.expand_path('web/models')) }
    end

    context 'under :load_paths' do
      let(:config) do
        {
          default: {
            setup: :memory
          },
          load_paths: ['api/models', 'web/models']
        }
      end

      it { expect(ROM::Roda::Plugin).to have_received(:load_files).with(File.expand_path('api/models')) }
      it { expect(ROM::Roda::Plugin).to have_received(:load_files).with(File.expand_path('web/models')) }
    end
  end
end
