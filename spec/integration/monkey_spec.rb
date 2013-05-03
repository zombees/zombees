require 'integration_spec_helper'
require 'zombees'

describe 'Running 3 servers' do
  let(:config) {{ provider: 'AWS', aws_access_key_id: 'foo', aws_secret_access_key: 'bar' }}

  it 'runs a command in parallel on all servers when they are ready' do
    queen = Zombees::Queen.new(worker_count: 3, command: "ls", config: config)
    queen.run
  end
end


