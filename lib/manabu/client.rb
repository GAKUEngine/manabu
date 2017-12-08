require_relative 'connection/auth'

module Manabu
  # General client interface which bundles together most client functionality
  class Client
    attr_accessor :auth, :transactor, :status

    # Initializes with login details and passes options to all linked instances
    def initialize(username, password, host, port = 80, **options)
      @status = :initializing
      @auth = Manabu::Connection::Auth.new(username, password, host, port, options)
      if @auth.success?
        @transactor = @auth.transactor
        @status = :connected
      else
        @status = :failed
        raise Error::Connection::Unauthorized
      end
    end

    # Performs a GET against the API
    def get(path, **args)
      @transactor.get(path, args)
    end

    def post(path, **args)
      @transactor.post(path, args)
    end

    def patch(path, **args)
      @transactor.patch(path, args)
    end

    def delete(path, **args)
      @transactor.delete(path, args)
    end
  end
end
