require 'spec_helper'
require 'zombees/queen'

module Zombees
  describe Queen do
    let(:swarm) { mock('Swarm') }
    let(:queen) {described_class.new(config: {}, worker_count: 3, command: "ls", swarm: swarm)}

    describe '#run' do
      it 'runs the swarm' do
        swarm.should_receive(:run)
        queen.run
      end
    end
  end
end
