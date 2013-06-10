require 'zombees'
require 'pry'
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.filter_run_excluding :integration
  if ENV['CI']
    config.filter_run_excluding :local
    require 'coveralls'
    Coveralls.wear!('test_frameworks')
  elsif ENV['COVERAGE']
    require 'simplecov'
    SimpleCov.start('test_frameworks')
  end

  config.before(:each) do
    #TODO Pull request to yell to expose level
    require 'yell'
    module Yell
      class Logger
        attr_accessor :level
      end
    end
    Yell[Object].level = Yell.level.gt(:error)
  end
end
