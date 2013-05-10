module Zombees
  module AbAdapter
    class Command
      attr_reader :requests, :concurrency, :url, :ab_options

      def initialize(options={})
        options = default.merge(options)
        @requests    = options[:requests]
        @concurrency = options[:concurrency]
        @url         = options[:url]
        @ab_options  = options[:ab_options]
      end

      def default
        {}
      end

      def run(worker)
        worker.run_command(command)
      end

      def command
        "ab -r -n #{requests} -c #{concurrency} " +
        %Q{-C "sessionid=fake" #{ab_options} "#{url}"}
      end
    end

    class Aggregator
      def parse
      end
    end
  end
end
