require 'forwardable'
require 'celluloid'
require 'celluloid/pmap'
require 'zombees/connection'
require 'fog'

module Zombees
  class Server
    include Celluloid
    attr_reader :config
    extend Forwardable
    def_delegator :@server, :ready?

    def initialize(connection)
      @connection = connection
    end

    def bootstrap()
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
  end
end
