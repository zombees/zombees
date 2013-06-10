require 'yaml'
require 'zombees/worker'
require 'zombees/swarm'
require 'zombees/honey_comb'
require 'yell'

module Zombees
  class Queen
    include Yell::Loggable
    attr_reader :config, :worker_count, :command, :swarm
    attr_writer :swarm_source

    def initialize(options = {})
      @config = options.fetch(:config)
      @worker_count = options.fetch(:worker_count)
      @command = options.fetch(:command)
      @swarm = options[:swarm]
    end

    def run
      logger.info "A swarm of zombie bees gathers..."
      swarm.run
    end

    def swarm
      swarm_source.call(SwarmOptions.new(
                        worker_count: worker_count,
                  command: command,
                  honey_comb: HoneyComb.new(config)))
    end

    def swarm_source
      @swarm_source ||= Swarm.public_method(:new)
    end

  end
end

