require 'spec_helper'

describe ROM::Roda::Plugin do
  it 'uses load_path relative to application by default' do
    subject.should_receive(:load_files).with(File.expand_path('models'))

    class RelativeLoadPathExample < Roda
      plugin :rom, :memory, load_path: 'models'
    end
  end
end
