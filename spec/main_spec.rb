require 'spec_helper'
require_relative '../main'

describe AWSConfig do
  describe 'self.run' do
    it 'runs' do
      Fog.mock!
      command = AWSConfig.run.last
      expect(command[:commands]).to eq 'ls'
    end
  end
end
