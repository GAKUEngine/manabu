require 'spec_helper'
require 'manabu/connection/transactor'

describe Manabu::Connection::Transactor do
  describe 'initialize' do
    it 'initializes, connects to the server, and checks status' do
      trans = Manabu::Connection::Transactor.new('localhost', 9000, false)
      expect(trans.status).to eq :running
    end
  end
end
