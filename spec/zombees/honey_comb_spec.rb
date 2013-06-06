require 'spec_helper'

module Zombees
  describe HoneyComb do
    it 'stores a configuration' do
      honeycomb = described_class.new(foo: :bar)
      expect(honeycomb.config[:foo]).to eq :bar
    end
  end
end
