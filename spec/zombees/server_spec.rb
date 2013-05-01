require 'spec_helper'
require 'zombees/server'

module Zombees
  describe Server do
    before(:each) { Fog.mock! }
    let(:config) {{
      provider: 'AWS',
      aws_access_key_id: 'asdf',
      aws_secret_access_key: 'ghi'
    }}
    let(:connection) { Connection.new(config) }

    it 'creates a server instance' do
      server = Server.new(connection)
      expect(server).to be_a(Server)
    end

    it 'prepares a server on bootstrap' do 
      server = Server.new(connection)
      server.bootstrap
      expect(server).to be_ready
    end

    it 'runs the command request on a server' do
      server = Server.new(connection)
      server.bootstrap
      stdout = server.run_command('ls')
      stdout.should_not be_nil
    end
  end
end
