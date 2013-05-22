module Zombees
  class AbAdapter
    attr_reader :config
    def initialize(config={})
      @config = config
    end

    def prepare(worker)
      Preparer.new.prepare(worker)
    end

    def run(worker)
      Command.new(config).run(worker)
    end

    def parse(output)
      Parser.new(output).parse
    end

    class Preparer
      def prepare(worker)
        worker.run_command('sudo apt-get -y update && sudo apt-get -y install apache2-utils')
      end
    end

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

    class Parser
      attr_reader :command_results
      def initialize(command_results)
        @command_results = command_results
      end

      def parse
        command_results.flatten.map do |command|
          self.class.parse(command.stdout)
        end
      end

      def self.parse(output)
        output.each_line.each_with_object({}) do |line, data|
          key, value = line.strip.split(/\s*:\s*/)
          if key
            key += " concurrent" if value =~ /concurrent/
            data[key.downcase.gsub(/\s+/, '_').to_sym] = value.to_f
          end
        end
      end
    end
  end
end
