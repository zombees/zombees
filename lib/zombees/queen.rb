require 'fog'
require 'yaml'
require 'zombees/worker'
require 'zombees/swarm'

module Zombees
  class Queen
    attr_reader :config, :worker_count, :command, :swarm

    def initialize(options = {})
      @config = options.fetch(:config)
      @worker_count = options.fetch(:worker_count)
      @command = options.fetch(:command)
      @swarm = options.fetch(:swarm) {
        Swarm.new(worker_count: worker_count, command: command, worker: Worker.new(connection))
      }
    end

    def run
      swarm.run
    end

    def connection
      @connection ||= Connection.new(config)
    end

    def _get_results
    end
  end
end

