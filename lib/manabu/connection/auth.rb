require_relative 'transactor'

module Manabu
  module Connection
    class Auth
      attr_accessor :username, :host, :port, :connection, :transactor, :token, :refresh_token

      def initialize(username, password, host, port, **options)
        @username = username
        @host = host
        @port = port
        @transactor = Transactor.new(host, port,
                                     options.fetch(:force_secure_connection, true),
                                     options.fetch(:transport_type, :msgpack),
                                     options)
        @connection = false
        _authenticate(username, password)

        ObjectSpace.define_finalizer(self, -> { @connection = false })
      end

      def success?()
        @connection
      end

      def stop()

      end

      def _authenticate(username, password)
        response = @transactor.post("authenticate", username: username, password: password)
        @connection = true

        @token = response[:tokens][:auth_token]
        @transactor.authorization = @token

        _refresh(response[:tokens])
      end

      def _refresh(tokens)
        @refresh_token = tokens[:refresh_token]
        thread = Thread.new do
          loop do
            break unless @connection
            sleep(120)
            refresh_response = transactor.post("authenticate/refresh",
                                               refresh_token: @refresh_token
                                              )
            @transactor.authorization = refresh_response[:tokens][:auth_token]
            @refresh_token = refresh_response[:tokens][:refresh_token]
          end
        end
      end
    end
  end
end
