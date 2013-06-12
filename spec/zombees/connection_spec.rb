require 'zombees/connection'
require 'celluloid/pmap'
require 'spec_helper'

module Zombees
  describe Connection do
    describe '#instance' do
      before do
        Fog::Compute.stub(:new).and_return(stub(key_pairs: stub(get: true)))
      end

#      it 'creates a single instance for the same config' do
#        config = {foo: 'bar'}
#        first_connection = Connection.instance(config)
#        second_connection = Connection.instance(config)
#
#        first_connection.should_not be_nil
#        first_connection.object_id.should == second_connection.object_id
#      end
#
#      it 'creates a multiple instances for different config' do
#        first_connection = Connection.instance(foo: :bar)
#        second_connection = Connection.instance(baz: :bat)
#
#        first_connection.should_not be_nil
#        first_connection.object_id.should_not == second_connection.object_id
#      end
#
#      it 'creates a single instance for the same config when instantiated from multiple threads', focus: true do
#        # Faking wait on fog instantiation
#        Fog::Compute.stub(:new) do
#          sleep(rand(0.1..0.3))
#          stub(key_pairs: stub(get: true))
#        end
#        config = {some_key: rand(1..10)}
#        connections = 10.downto(1).pmap do
#          Connection.instance(config)
#        end
#
#        connections.each_cons(2) do |first, second|
#          first.should_not be_nil
#          first.object_id.should == second.object_id
#        end
#      end
    end
  end
end
