require 'fog'
require 'yaml'
require 'zombees/worker'
require 'zombees/swarm'
require 'yell'

module Zombees
  class Queen
    include Yell::Loggable
    attr_reader :config, :worker_count, :command, :swarm
    attr_accessor :swarm

    def initialize(options = {})
      @config = options.fetch(:config)
      @worker_count = options.fetch(:worker_count)
      @command = options.fetch(:command)
      @swarm = options[:swarm]
    end

    def worker_source
      @worker_source ||= Worker.public_method(:new)
    end
    def run
      logger.info "A swarm of zombie bees gathers..."
      swarm.run
    end
    
    def swarm
      @swarm ||= 
        Swarm.new(worker_count: worker_count, 
                  command: command, 
                  worker: worker_source.call(connection)) 
    end

    def connection
      @connection ||= Connection.new(config)
    end

    def _get_results
    end
  end
end

