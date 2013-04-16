require 'fog'
require 'yaml'

aws_config = YAML.load_file('aws_config.yml')
p aws_config
connection = Fog::Compute.new(aws_config)

server = connection.servers.bootstrap(
  private_key_path:  'tourfleet',
  public_key_path:   'tourfleet.pub',
  username:          'ubuntu'
)

server.wait_for { ready? }
p server.ssh('ls')

