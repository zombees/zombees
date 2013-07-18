require 'yaml'
require 'zombees'
require 'zombees/ab_adapter'

aws_config = YAML.load_file('aws_config.yml').symbolize_keys!

url = URL_TO_TEST
adapter = Zombees::AbAdapter.new requests: 10, concurrency: 10, url: "#{url}/"
result = Zombees::Queen.new(config: aws_config, worker_count: 2, command: adapter).run
puts result.inspect
