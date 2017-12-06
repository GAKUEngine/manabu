require 'spec_helper'
require 'manabu/connection/auth'

describe Manabu::Connection::Auth do
  describe 'initialize' do
    it 'Authorizes and obtains auth tokens' do
      auth = Manabu::Connection::Auth.new('admin', 123456, 'localhost', 9000,
                                          force_secure_connection: false)
      expect(auth.success?).to be_truthy
    end

    it 'Authorizes and refreshes the auth token within a set period of time', :timeouts do
      auth = Manabu::Connection::Auth.new('admin', 123456, 'localhost', 9000,
                                          force_secure_connection: false)
      refresh_token = auth.refresh_token
      timeout = 130
      puts "\n⏰Waiting for refresh timeout (#{timeout} seconds)...\n"
      sleep(timeout)
      expect(auth.refresh_token).to_not eq refresh_token
      puts [auth.refresh_token, refresh_token].inspect
    end
  end
end
