require 'integration_spec_helper'
require 'zombees'
require 'zombees/ab_adapter'

describe 'Running 3 servers', integration: true do
  let(:config) {{ provider: 'AWS', aws_access_key_id: 'foo', aws_secret_access_key: 'bar' }}

  class Fog::SSH::Mock
    alias_method :original_run, :run

    def run(commands, &blk)
      Array(commands).map do |command|
        result = Fog::SSH::Result.new(command)
      end
    end
  end

  it 'runs a command in parallel on all servers when they are ready' do
    queen = Zombees::Queen.new(worker_count: 3, command: Zombees::AbAdapter.new, config: config)
    queen.run
  end
end


