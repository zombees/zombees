require 'fog'

class HoneyComb
  attr_reader :config

  def worker
    # TODO TEMPORARELY!
    require 'zombees/worker'
    Worker.new(connection)
  end
  def initialize(config)
    @config = config
  end

  def connection
    @connection ||= Connection.new(config)
  end

end
