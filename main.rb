require 'fog'
require 'yaml'
require_relative './lib/server.rb'

module AWSConfig
  def self.run
    aws_config = YAML.load_file('aws_config.yml')
    server = Server.new(aws_config)
    server.bootstrap
    p server.run_command('ls')
  end
end

AWSConfig.run
