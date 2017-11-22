require 'spec_helper'
require 'manabu/transactor'

describe Manabu::Transactor do
  describe 'initialize' do
    it 'initializes, connects to the server, and checks status' do
      trans = Manabu::Transactor.new('localhost', 9000, false)
      expect(trans.status).to eq :running
    end
  end
end
