require 'spec_helper'
require 'zombees/queen'

module Zombees
  describe Queen do
    let(:server) { mock('Server') }
    let(:queen) {described_class.new(config: {}, worker_count: 3, command: "ls", server: server)}

    describe '#run' do
      it 'bootstraps servers if needed' do
        server.should_receive(:bootstrap).exactly(3).times.and_return(stub(run_command: true))
        queen.run

        queen.active_worker_count.should == 3
      end

      it 'does not bootstraps servers' do
        server.should_receive(:bootstrap).exactly(3).times.and_return(stub(run_command: true))

        queen.run
        queen.run
      end

      it 'runs the specified command' do
        bootstrapped_servers = 3.downto(1).map do |i|
          server = mock('Server')
          server.should_receive(:run_command).with("ls")
          server
        end
        queen.instance_variable_set(:@bootstrapped_servers, bootstrapped_servers)

        queen.run
      end
    end
  end
end
