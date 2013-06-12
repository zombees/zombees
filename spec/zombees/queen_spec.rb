require 'spec_helper'
require 'zombees/queen'

module Zombees
  describe Queen do
    let(:swarm) { mock('Swarm') }
    let(:queen) {described_class.new(config: {}, worker_count: 3, command: "ls", swarm: swarm)}

    before do
      Connection.stub(:import_key_pair)
    end
    describe '#run' do
      it 'runs the swarm' do
        swarm.should_receive(:run)
        queen.swarm_source = ->(options) { swarm }
        queen.run
      end
    end

    it 'creates a swarm with default options' do
      queen = described_class.new(config: {foo: :bar}, worker_count: 3, command: 'ls')
      queen.swarm_source = ->(options) do
        options.honey_comb.config[:foo].should eq :bar
        stub(run: true)
      end
      queen.run
    end
  end
end
