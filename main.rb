require 'fog'
require 'yaml'
require_relative './lib/server.rb'

module AWSConfig
  def self.run
    aws_config = YAML.load_file('aws_config.yml')

    connection = Connection.new(aws_config)

    bootstraped_servers = 3.downto(1).pmap do
      server = Server.new(connection)
      server.bootstrap(aws_config)
    end
    commands_results = bootstraped_servers.pmap do |server|
      server.run_command("ls")
    end

    commands_results.each do |cmd|
      puts cmd.inspect + Time.now.to_s
    end
  end
end

AWSConfig.run
