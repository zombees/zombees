require 'celluloid'
require 'celluloid/pmap'

module Zombees
  class Swarm
    attr_reader :worker_count, :command, :worker

    def initialize(options)
      @worker_count = options[:worker_count]
      @command = options[:command]
      @worker = options[:worker]
      @population = options[:population]
    end

    def breed
      @population ||= worker_count.downto(1).pmap do
        worker.bootstrap
      end
    end

    def population
      breed
    end

    def run
      population.pmap do |worker|
        worker.run_command(@command)
      end
    end
  end
end
