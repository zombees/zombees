require 'fog'
require 'yaml'

module AWSConfig
  def self.run
    aws_config = YAML.load_file('aws_config.yml')
    connection = Fog::Compute.new(aws_config)

    server = connection.servers.bootstrap(
      private_key_path:  'tourfleet',
      public_key_path:   'tourfleet.pub',
      username:          'ubuntu'
    )

    server.wait_for { ready? }
    server.ssh('ls')
  end

end
