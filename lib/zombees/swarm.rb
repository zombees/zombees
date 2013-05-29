require 'celluloid'
require 'celluloid/pmap'

module Zombees
  class Swarm
    attr_reader :worker_count, :command, :worker

    def initialize(options)
      @worker_count = options[:worker_count]
      @adapter = options[:command]
      @worker = options[:worker]
      @population = options[:population]
    end

    def breed
      @population ||= worker_count.downto(1).pmap do
        begin 
          worker.bootstrap.tap { |w| @adapter.prepare(w) }
        rescue => e
          worker.shutdown(e)
        end
      end
    end

    def population
      breed
    end

    def run
      results = population.pmap do |worker|
        begin
          @adapter.run(worker)
        rescue => e
        ensure
          worker.shutdown
        end
      end
      @adapter.aggregate(results)
    end
  end
end
