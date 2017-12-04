require_relative 'connection/auth'

module Manabu
  # General client interface which bundles together most client functionality
  class Client
    attr_accessor :auth, :transactor
    def initialize(username, password, host, port = 80, **options)
      @auth = Manabu::Connection::Auth.new(username, password, host, port, options)
      if @auth.success?
        @transactor = @auth.transactor
      else
        raise Error::Connection::Unauthorized
      end
    end

    # Performs a GET against the API
    def get(path, **args)
      @transactor.get(path, args) #.merge(@auth.token))
    end

    def post(path, **args)
      @transactor.post(path, args) #.merge(@auth.token))
    end

    def patch(path, **args)
      @transactor.patch(path, args.merge(@auth.token))
    end

    def delete(path, **args)
      @transactor.delete(path, args.merge(@auth.token))
    end
  end
end
