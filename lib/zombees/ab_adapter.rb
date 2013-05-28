module Zombees
  class AbAdapter
    attr_reader :config
    attr_writer :command_source
    attr_writer :preparer_source
    attr_writer :parser_source
    def initialize(config={})
      @config = config
    end

    def command_source; @command_source ||= Command.public_method(:new) end 
    def preparer_source; @preparer_source ||= Preparer.new end
    def parser_source(output_of_commands); @parser_source ||= Parser.new(output_of_commands) end
    private :command_source, :preparer_source, :parser_source

    def prepare(worker)
      preparer_source.prepare(worker)
    end

    def run(worker)
      command_source.call(config).run(worker)
    end

    def parse(output_of_commands)
      parser_source(output_of_commands).parse
    end

    def aggregate(output_of_commands)
      parse_result = parse(output_of_commands)
      Aggregator.new(parse_result).aggregate
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
      attr_reader :parsed_results
      def initialize(parsed_results)
        @parsed_results = parsed_results
      end

      def sum(key)
        values = parsed_results.map { |res| res[key] }.compact
        values.inject(:+)
      end

      def average(key)
        values = parsed_results.map { |res| res[key] }.compact
        if total_values = values.inject(:+)
          total_values / values.count
        end
      end

      def hash_result(key, aggregator)
        value = self.send(aggregator, key)
        value ? {key => value} : {}
      end

      def aggregate
        {}.tap do |result|
          result.merge! hash_result(:complete_requests, :sum)
          result.merge! hash_result(:failed_requests, :sum)
          result.merge! hash_result(:time_per_request, :average)
        end
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
