require 'spec_helper'

describe ROM::Roda::Plugin do
  before do
    allow(ROM::Roda::Plugin).to receive(:load_files)
  end

  it 'uses load_path relative to application by default' do
    class RelativeLoadPathExample < Roda
      plugin :rom, {
        default: {
          setup: :memory
        },
        load_path: 'models'
      }
    end

    expect(ROM::Roda::Plugin).to have_received(:load_files).with(File.expand_path('models'))
  end
end
