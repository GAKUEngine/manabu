require_relative 'connection/auth'

module Manabu
  # General client interface which bundles together most client functionality
  class Client
    attr_accessor :auth, :transactor
    def initialize(email, password, host, port = 80, options = {})
      @auth = Manabu::Connection::Auth.new(email, password, host, port)
      if @auth.success?
        @transactor = @auth.transactor
      else
        raise Error::Connection::Unauthorized
      end
    end

    # def login(username, password)
    #   Auth.login(username, password)
    # end

  end
end
