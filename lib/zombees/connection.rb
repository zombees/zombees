require 'fog'
module Zombees
  class Connection
    extend Forwardable
    def_delegator :@connection, :servers

    def self.import_key_pair(config)
      connection = Fog::Compute.new(config)
      connection.import_key_pair(:fog_default, IO.read('tourfleet.pub')) if connection.key_pairs.get(:fog_default).nil?
    end
    def initialize(config)
      @connection = Fog::Compute.new(config)
    end

  end
end
