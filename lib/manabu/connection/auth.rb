require_relative 'transactor'

module Manabu
  module Connection
    class Auth
      attr_accessor :email, :password, :host, :port, :connection, :transactor

      def initialize(email, password, host, port)
        @email = email
        @password = password
        @host = host
        @port = port
        @transactor = Transactor.new(host, port, false)
        @connection = false
        _authenticate

        ObjectSpace.define_finalizer(self, -> { @connection = false })
      end

      def success?
        @connection
      end

      def stop

      end

      def _authenticate
        response = transactor.post("v1/authenticate", email: email, password: password)
        @connection = true
        _refresh(response[:tokens])
      end

      def _refresh(tokens)
        thread = Thread.new do
          refresh_token = tokens[:refresh_token]

          loop do
            break unless @connection
            sleep(120)
            refresh_response = transactor.post( "v1/authenticate/refresh",
              refresh_token: refresh_token
            )
            refresh_token = refresh_response[:tokens][:refresh_token]
          end
        end
      end

    end
  end
end
