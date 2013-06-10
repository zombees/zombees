require 'zombees/worker'
require 'zombees/connection'
require 'thread'

module Zombees
  class HoneyComb
    attr_reader :config

    def worker
      Worker.new(connection)
    end

    def initialize(config)
      @config = config
    end

    def connection
      Connection.instance(config)
    end
  end
end
