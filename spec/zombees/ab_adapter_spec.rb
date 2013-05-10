require 'spec_helper'
require 'zombees/ab_adapter'

module Zombees
  module AbAdapter
    describe Command do
      context 'command generation' do
        subject { described_class.new(requests: 1000, concurrency: 5, url: 'http://a.co', ab_options: '--foo').command }
        it { should match '^ab' }
        it("doesn't exit on socket receive") { should match '-r' }
        it('should specify number of requests') { should match '-n 1000' }
        it('should specify concurrency') { should match '-c 5' }
        it('should set a dummy session id') { should match '-C "sessionid=fake"' }
        it('should send extra options to ab') { should match '--foo' }
        it('should pass the url') { should match '"http://a.co"$' }
      end

      it 'generate a valid ab command', integration: true do
        command = described_class.new(requests: 1, concurrency: 1, url: 'http://www.google.com/').command
        result = system(command)
        result.should be_true
      end

      it 'executes a command on a worker' do
        subject.stub(:command).and_return('ab')
        worker = mock('Worker')
        worker.should_receive(:run_command).with('ab')
        subject.run(worker)
      end
    end
  end
end
