require 'spec_helper'
require 'manabu/connection/auth'

describe Manabu::Connection::Auth do
  describe 'initialize' do
    it 'initializes, connects to the server, and checks status' do
      auth = Manabu::Connection::Auth.new('admin', 123456, 'localhost', 9000, force_secure_connection: false)
      expect(auth.success?).to be_truthy
    end

    it 'initializes, connects to the server, and checks status' do
      auth = Manabu::Connection::Auth.new('admin', 123456, 'localhost', 9000, force_secure_connection: false)
      refresh_token = auth.refresh_token
      puts 'Waiting for refresh timeout 130~ sec'
      sleep(130)
      expect(auth.refresh_token).to_not eq refresh_token
      puts [auth.refresh_token, refresh_token].inspect
    end
  end
end
