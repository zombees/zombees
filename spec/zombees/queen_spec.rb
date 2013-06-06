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

    it 'creates a swarm with default options' do
      queen = described_class.new(config: {foo: :bar}, worker_count: 3, command: 'ls')
      queen.swarm = stub
      #queen.swarm = stub
      #queen.swarm.worker_source.should be_a(Worker)
    end
  end
end
