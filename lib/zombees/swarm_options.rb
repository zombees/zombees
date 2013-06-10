class SwarmOptions
  attr_reader :options
  def initialize(options)
    @options = options
  end

  def worker_count
    options[:worker_count]
  end

  def command
    options[:command]
  end

  def honey_comb
    options[:honey_comb]
  end
end
