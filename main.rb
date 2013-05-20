require 'fog'
require 'yaml'
require 'zombees/queen'
require 'zombees/ab_adapter'

aws_config = YAML.load_file('aws_config.yml').symbolize_keys!

adapter = Zombees::AbAdapter.new requests: 10, concurrency: 10, url: 'http://www.google.com/'
result = Zombees::Queen.new(config: aws_config, worker_count: 1, command: adapter).run
puts result.inspect
