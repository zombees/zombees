require 'fog'
require 'yaml'
require_relative './lib/server.rb'

module AWSConfig
  def self.run
    aws_config = YAML.load_file('aws_config.yml')

    connection = Fog::Compute.new(aws_config)
    connection.import_key_pair(:fog_default, IO.read('tourfleet.pub')) if connection.key_pairs.get(:fog_default).nil?

    bootstraped_servers = 3.downto(1).pmap do
      server = Server.new
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
