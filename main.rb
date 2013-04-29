require 'fog'
require 'yaml'
require_relative './lib/server.rb'

module AWSConfig
  def self.run
    aws_config = YAML.load_file('aws_config.yml')

    commands = 3.downto(1).pmap do
      server = Server.new
      server.bootstrap(aws_config)
      server.run_command('ls')
    end
    commands.each do |cmd|
      puts cmd + Time.now.to_s
    end
  end
end

AWSConfig.run
