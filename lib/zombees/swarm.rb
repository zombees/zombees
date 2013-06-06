require 'celluloid'
require 'celluloid/pmap'
require 'yell'

module Zombees
  class Swarm
    attr_reader :worker_count, :command, :worker
    include Yell::Loggable

    def initialize(options)
      @worker_count = options[:worker_count]
      @adapter = options[:command]
      @worker = options[:worker]
      @population = options[:population]
    end

    def breed
      logger.info "Resurrecting the bees population of #{worker_count}"
      @population ||= worker_count.downto(1).pmap do |index|
        begin 
          logger.info "Bee #{ index } is getting ready to fight"
          worker.bootstrap.tap { |w| @adapter.prepare(w) }
        rescue => e
          logger.error "ARGH! Bee #{ index } stayed dead: #{e.inspect}"
          worker.shutdown(e)
        end
      end

      #logger.debug ">>> population"
      #@population.map { |w| logger.debug "worker: #{ w.object_id }; server: #{ w.server.inspect }" }
    end

    def population
      breed
    end

    def run
      logger.info "The swarm lurches toward the target..."
      results = population.pmap do |worker|
        begin
          logger.info "A zombie bee is attacking the target!"
          @adapter.run(worker)
        rescue => e
          logger.error "A zombie bee can't reach the brains due to #{e.message}"
          logger.debug e.backtrace
        ensure
          logger.info "A zombie bee is full of brains... Going back to the grave"
          #logger.debug "worker: #{ worker.object_id } server: #{ worker.server.inspect }"
          worker.shutdown
        end
      end
      logger.info "Digesting acquired brains"
      @adapter.aggregate(results)
    end
  end
end
