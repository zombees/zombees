require 'fog'
module Zombees
  class Connection
    @mutex = Mutex.new 
    extend Forwardable
    def_delegator :@connection, :servers
    
    def self.instance(config)
      @mutex.synchronize {
        @registry ||= {}
        @registry[config] ||= self.new(config)
      }
    end

    private
    def initialize(config)
      puts "CREATING Connectiong from #{caller.join("\n")}"
      @connection = Fog::Compute.new(config)
      @connection.import_key_pair(:fog_default, IO.read('tourfleet.pub')) if @connection.key_pairs.get(:fog_default).nil?
    end
  end
end
