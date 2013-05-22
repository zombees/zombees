require 'spec_helper'
require 'fog'
require 'zombees/ab_adapter'

module Zombees
  describe AbAdapter do


    it 'prepares the worker supplied' do
      worker = mock('worker')
      worker.should_receive(:run_command).with(/apt-get -y update.*apt-get -y install/)
      subject.prepare(worker)
    end

    it 'runs a command on a command object' do
      worker = stub('worker')
      mock_command = mock('command')
      AbAdapter::Command.stub(:new).and_return(mock_command)
      mock_command.should_receive(:run).with(worker)
      subject.run(worker)
    end

    it 'runs a command with specified config' do
      worker = stub('worker')
      mock_command = mock('command')
      AbAdapter::Command.stub(:new).with(hello: 'world').and_return(mock_command)
      mock_command.should_receive(:run).with(worker)

      described_class.new(hello: 'world').run(worker)
    end

    it 'parsers the command result' do
      mock_parser = mock('parser')
      AbAdapter::Parser.stub(:new).with(hello: 'world').and_return(mock_parser)
      mock_parser.should_receive(:parse)

      described_class.new.parse(hello: 'world')
    end

  end

  describe AbAdapter::Command do
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

  describe AbAdapter::Parser do
    let(:output) { IO.read File.expand_path("../../fixtures/ab.txt", __FILE__) }

    it 'transforms results of the ab command into a hash of data' do
      data = described_class.parse(output)
      data.should have_key(:requests_per_second)
      data[:requests_per_second].should eq 120.06
      data[:time_per_request].should eq 83.295
      data[:time_per_request_concurrent].should eq 8.329
    end

    it 'transforms results of the run command' do
      command_results = 3.downto(1).map do |i|
        [ stub(:command, stdout: output) ]
      end
      parser = described_class.new(command_results)
      data = parser.parse
      data.should have(3).results
    end
  end
end

describe Fog::SSH::Result do
  it { described_class.instance_methods.should include :stdout }
end
