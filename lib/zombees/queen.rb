require 'fog'
require 'yaml'
require 'zombees/server'

module Zombees
  class Queen
    attr_reader :config, :worker_count, :command, :server, :bootstrapped_servers

    def initialize(options = {})
      @config = options.fetch(:config)
      @worker_count = options.fetch(:worker_count)
      @command = options.fetch(:command)
      @server = options.fetch(:server) {|el| Server.new(connection)}
    end

    def run
      _bootstrap
      _run_command
    end

    def active_worker_count
      bootstrapped_servers.size
    end
    def connection
      @connection ||= Connection.new(config)
    end

    def _bootstrap()
      @bootstrapped_servers ||= worker_count.downto(1).pmap do
        server.bootstrap(config)
      end
    end

    def _run_command
      bootstrapped_servers.pmap do |server|
        server.run_command(@command)
      end
    end

    def _get_results
    end
  end

  def self.run
    aws_config = YAML.load_file('aws_config.yml')

    connection = Connection.new(aws_config)

    bootstraped_servers = 3.downto(1).pmap do
    end
    commands_results = bootstraped_servers.pmap do |server|
      server.run_command("ls")
    end

    commands_results.each do |cmd|
      puts cmd.inspect + Time.now.to_s
    end
  end
end

