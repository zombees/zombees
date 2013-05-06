module Zombees
  module AbAdapter
    class Command
      def run(worker)
        worker.run_command(command)
      end
    end
    class Aggregator
      def parse
      end
    end
  end
end
