require 'spec_helper'
require 'zombees/queen'

module Zombees
  describe Queen do
    let(:config) {{ key: "some key", secret: "some secret" }}

    it 'initializes with config, worker count, and command' do
      queen = described_class.new(config: config, worker_count: 3, command: "ls")
    end

    describe '#run' do
      it 'calls bootstrap' do
        queen = described_class.new(config: config, worker_count: 3, command: "ls")
        queen.should_receive(:_bootstrap).once
        queen.run()
      end
    end

    describe '_bootstrap' do
      it 'bootstraps servers if needed' do
        queen = described_class.new(config: config, worker_count: 3, command: "ls")
        queen.stub(:connection)
        mock_server = double('Server')
        mock_server.should_receive(:bootstrap).exactly(3).times.and_return({})

        queen._bootstrap(mock_server).should have(3).server
      end

      it 'does not bootstraps servers' do
        queen = described_class.new(config: config, worker_count: 3, command: "ls")
        queen.stub(:connection)
        mock_server = double('Server')
        mock_server.should_receive(:bootstrap).exactly(3).times.and_return({})

        queen._bootstrap(mock_server)
        queen._bootstrap(mock_server)
      end
    end
  end
end
