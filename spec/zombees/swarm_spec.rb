require 'spec_helper'
require 'zombees/swarm'

module Zombees
  describe Swarm do
    let(:server) { mock('Server') }
    let(:worker) { mock('Worker', bootstrap: server) }

    it 'bootstraps requested number of servers' do
      swarm = described_class.new(worker_count: 3, command: stub(run: true), worker: worker)
      worker.should_receive(:bootstrap).exactly(3).times.and_return(stub(run_command: true))

      swarm.breed
    end
    it 'does not breeds when population is full' do
      swarm = described_class.new(worker_count: 3, command: stub(run: true), worker: worker)
      worker.should_receive(:bootstrap).exactly(3).times.and_return(stub(run_command: true))

      swarm.breed
      swarm.breed
    end

    class MockCommand

    end
    it 'distributes a command to the population of workers' do
      servers = (1..3).map { |i| mock("Server#{i}") }
      command = MockCommand.new
      stub_const('AbAdapter::Command', Class.new)
      #command.should_receive(:run).exactly(servers.size).times.and_return(true)
      swarm = described_class.new(command: AbAdapter, population: servers)
      swarm.run
    end

  end
end
