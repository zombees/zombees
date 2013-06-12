require 'spec_helper'

module Zombees
  describe HoneyComb do
    before do
      Connection.stub(:import_key_pair)
    end
    it 'stores a configuration' do
      honeycomb = described_class.new(foo: :bar)
      expect(honeycomb.config[:foo]).to eq :bar
    end
    it 'imports key pair' do
      Connection.should_receive(:import_key_pair).with(foo: :bar)
      honeycomb = described_class.new(foo: :bar)
    end
  end
end
