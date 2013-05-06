require 'spec_helper'
require 'zombees/ab_adapter'

module Zombees
  describe AbAdapter do
    it 'executes a command on a worker' do
      adapter = described_class.new
      adapter.stub(:command).and_return('ab')
      worker = mock('Worker')
      worker.should_receive(:run_command).with('ab')
      adapter.run(worker)
    end
  end
end
