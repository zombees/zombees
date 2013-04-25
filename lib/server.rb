require 'forwardable'

class Server
  attr_reader :config
  extend Forwardable
  def_delegator :@server, :ready?

  def initialize(config)
    @config = config
  end

  def bootstrap 
    connection = Fog::Compute.new(config)

    @server = connection.servers.bootstrap(
      private_key_path:  'tourfleet',
      public_key_path:   'tourfleet.pub',
      username:          'ubuntu'
    )

    @server.wait_for { ready? }
  end

  def run_command(command)
    result = @server.ssh(command)
    result
  end
end
