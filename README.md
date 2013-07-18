[![Build Status](https://travis-ci.org/zombees/zombees.png?branch=master)](https://travis-ci.org/zombees/zombees)
[![Code Climate](https://codeclimate.com/github/zombees/zombees.png)](https://codeclimate.com/github/zombees/zombees)
[![Coverage Status](https://coveralls.io/repos/zombees/zombees/badge.png?branch=master)](https://coveralls.io/r/zombees/zombees?branch=master)

![logo](https://raw.github.com/zombees/zombees/master/zombee.png)

## Installation

Add this line to your application's Gemfile:

    gem 'zombees'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zombees

## Example usage

```ruby
# ab_adapter_example.rb
require 'yaml'
require 'zombees'
require 'zombees/ab_adapter'

aws_config = YAML.load_file('aws_config.yml').symbolize_keys!

adapter = Zombees::AbAdapter.new requests: 10, concurrency: 10, url: TEST_URL
result = Zombees::Queen.new(config: aws_config, worker_count: 2, command: adapter).run
puts result.inspect
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


TODO
------------
- Simple  CLI
- Verbose mode
- Adapters for different command to run
  - Siege
  - Tourbus
