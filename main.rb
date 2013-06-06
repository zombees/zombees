require 'fog'
require 'yaml'
require 'zombees'
require 'zombees/ab_adapter'

aws_config = YAML.load_file('aws_config.yml').symbolize_keys!

adapter = Zombees::AbAdapter.new requests: 10, concurrency: 10, url: 'https://prod-website-as-backend.elasticbeanstalk.com/Account/LogOn/'
result = Zombees::Queen.new(config: aws_config, worker_count: 2, command: adapter).run
puts result.inspect
