require 'spec_helper'
require 'zombees/swarm'
require 'zombees/ab_adapter'

module Zombees
  module NoopAdapter
    def self.prepare(worker)

    end
    def self.run(worker)

    end
    def self.aggregate(whatever)

    end
    class Command

    end
  end
  class NoopWorker
    def bootstrap; self end
  end
  describe Swarm do
    let(:worker) { NoopWorker.new }
    let(:noop_adapter) { NoopAdapter }

    it 'bootstraps requested number of servers' do
      swarm = described_class.new(worker_count: 3, command: noop_adapter, worker: worker)
      worker.should_receive(:bootstrap).exactly(3).times

      swarm.breed
    end

    it 'attempts shutdown if bootstrap fails' do
      swarm = described_class.new(worker_count: 3, command: noop_adapter, worker: worker)
      e = RuntimeError.new
      worker.stub(:bootstrap).and_raise(e)
      worker.should_receive(:shutdown).exactly(3).times.with(e)

      swarm.breed
    end

    it 'adds command-specific configuration to workers' do
      swarm = described_class.new(worker_count: 3, command: noop_adapter, worker: worker)
      noop_adapter.should_receive(:prepare).with(worker).exactly(3).times

      swarm.breed
    end

    it 'does not breed when already populated' do
      swarm = described_class.new(worker_count: 3, command: noop_adapter, worker: worker)
      worker.should_receive(:bootstrap).exactly(3).times.and_return(stub(run_command: true))

      swarm.breed
      swarm.breed
    end

    it 'distributes a command to the population of workers' do
      workers = (1..3).map { |i| mock("Worker#{i}", shutdown: true) }

      NoopAdapter.should_receive(:run).exactly(workers.size).times.and_return(true)
      NoopAdapter.should_receive(:aggregate).with([true, true, true]).once.and_return(true)
      swarm = described_class.new(command: NoopAdapter, population: workers)
      swarm.run
    end

    it 'attempts to shutdown worker if run fails' do
      worker = mock('Worker')

      e = RuntimeError.new
      NoopAdapter.stub(:run).and_raise(e)
      swarm = described_class.new(command: NoopAdapter, population: [worker])
      worker.should_receive(:shutdown)
      swarm.run
    end

    it 'attempts to shutdown worker if run fails' do
      worker = mock('Worker')

      e = RuntimeError.new
      NoopAdapter.stub(:aggregate).and_return(true)
      swarm = described_class.new(command: NoopAdapter, population: [worker])
      worker.should_receive(:shutdown)
      swarm.run
    end
  end
end
