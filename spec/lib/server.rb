require 'spec_helper'

describe Server do
  it 'creates a server instance' do
    server = Server.new(config)
    expect(server).to be_a(Server)
  end
end
