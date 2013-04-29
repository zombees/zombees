require 'forwardable'
require 'celluloid'
require 'celluloid/pmap'
require_relative 'connection'

class Server
  include Celluloid
  attr_reader :config
  extend Forwardable
  def_delegator :@server, :ready?

  def initialize(connection)
    @connection = connection
  end

  def bootstrap(config)
    puts "bootstraping... " + Time.now.to_s

    @server = @connection.servers.bootstrap(
      private_key_path:  'tourfleet',
      public_key_path:   'tourfleet.pub',
      username:          'ubuntu'
    )

    @server.wait_for { ready? }
    self
  end

  def run_command(command)
    puts "running a command #{command}... " + Time.now.to_s
    result = @server.ssh(command)
    result
  end
end
