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
      Connection.import_key_pair(config)
    end

    def connection
      Connection.new(config)
    end
  end
end
