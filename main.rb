require 'fog'
require 'yaml'
require 'zombees/queen'
require 'zombees/ab_adapter'

aws_config = YAML.load_file('aws_config.yml').symbolize_keys!

result = Zombees::Queen.new(config: aws_config, worker_count: 1, command: Zombees::AbAdapter).run
puts result.inspect
