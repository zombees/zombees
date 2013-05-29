require 'integration_spec_helper'
require 'zombees'

module Zombees
  describe Worker, integration: true do
    before(:each) { Fog.mock! }
    let(:config) {{
      provider: 'AWS',
      aws_access_key_id: 'asdf',
      aws_secret_access_key: 'ghi'
    }}
    let(:connection) { Connection.new(config) }

    it 'creates a worker instance' do
      worker = described_class.new(connection)
      expect(worker).to be_a(described_class)
    end

    it 'prepares a worker on bootstrap' do 
      worker = described_class.new(connection)
      worker.bootstrap
      expect(worker).to be_ready
    end

    it 'should destroy the server if its ready', focus: true do 
      worker = described_class.new(connection)
      worker.bootstrap
      worker.server.should_receive(:destroy)
      worker.shutdown
    end

    it 'should not destroy the server if ts not ready to shutdown', focus: true do 
      worker = described_class.new(connection)
      worker.bootstrap
      worker.server.stub(:ready?, false)
      worker.server.should_not_receive(:destroy)
      worker.shutdown
    end

    it 'runs the command request on a worker' do
      worker = described_class.new(connection)
      worker.bootstrap
      stdout = worker.run_command('ls')
      stdout.should_not be_nil
    end
  end
end
