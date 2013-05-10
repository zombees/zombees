require 'fog'
require 'yaml'
require 'zombees/queen'
require 'zombees/ab_adapter'

aws_config = YAML.load_file('aws_config.yml')

result = Zombees::Queen.new(config: aws_config, worker_count: 3, command: Zombees::AbAdapter).run
puts result.inspect
