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
end
