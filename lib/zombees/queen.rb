require 'fog'
require 'yaml'
require 'zombees/worker'
require 'zombees/swarm'

module Zombees
  class Queen
    attr_reader :config, :worker_count, :command, :swarm, :bootstrapped_servers

    def initialize(options = {})
      @config = options.fetch(:config)
      @worker_count = options.fetch(:worker_count)
      @command = options.fetch(:command)
      @swarm = options.fetch(:swarm) {
        Swarm.new(worker_count: worker_count, command: command, worker: Worker.new(connection))
      }
    end

    def run
      swarm.run
    end

    def connection
      @connection ||= Connection.new(config)
    end

    def _get_results
    end
  end

  def self.run
    aws_config = YAML.load_file('aws_config.yml')

    connection = Connection.new(aws_config)

    bootstraped_servers = 3.downto(1).pmap do
    end
    commands_results = bootstraped_servers.pmap do |swarm|
      swarm.run_command("ls")
    end

    commands_results.each do |cmd|
      puts cmd.inspect + Time.now.to_s
    end
  end
end

