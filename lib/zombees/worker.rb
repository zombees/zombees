require 'forwardable'
require 'celluloid'
require 'celluloid/pmap'
require 'zombees/connection'
require 'fog'
require 'yell'

module Zombees
  class Worker
    include Celluloid
    include Yell::Loggable
    attr_reader :config
    attr_reader :server
    extend Forwardable
    def_delegator :@server, :ready?

    def initialize(connection)
      @connection = connection
    end

    def bootstrap
      @server = @connection.servers.bootstrap(
        private_key_path:  'tourfleet',
        public_key_path:   'tourfleet.pub',
        username:          'ubuntu'
      )

      @server.wait_for { ready? }
      self
    end

    def run_command(command)
      result = @server.ssh(command)
      result
    end

    def shutdown
      if @server && @server.ready?
        @server.destroy
      else
        logger.error "zombie bee is too badly damaged to get to the graveyard"
      end
    end
  end
end
