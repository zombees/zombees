require 'spec_helper'
require 'zombees/queen'

module Zombees
  describe Queen do
    let(:queen) {described_class.new(config: {}, worker_count: 3, command: "ls")}

    describe '_bootstrap' do
      it 'bootstraps servers if needed' do
        mock_server = double('Server')
        mock_server.should_receive(:bootstrap).exactly(3).times.and_return({})

        queen._bootstrap(mock_server).should have(3).server
      end

      it 'does not bootstraps servers' do
        mock_server = double('Server')
        mock_server.should_receive(:bootstrap).exactly(3).times.and_return({})

        queen._bootstrap(mock_server)
        queen._bootstrap(mock_server)
      end
    end
  end
end
