require 'faraday'
require 'json'
require 'pry'
module Manabu
  class Auth
    attr_accessor :email, :password, :host, :port, :connection

    def initialize(email, password, host, port)
      @email = email
      @password = password
      @host = host
      @port = port
      @connection = false
      _authenticate

      ObjectSpace.define_finalizer(self, -> { @connection = false })

    end

    def stop

    end

    private

    def _authenticate
      response = Faraday.post("http://#{host}:#{port}/api/v1/authenticate",
        { email: email, password: password}
      )
      _refresh(JSON.parse(response.body)['tokens'])
      @connection = true
    end


    def _refresh(tokens)
      thread = Thread.new do
        refresh_token = tokens['refresh_token']

        loop do
          break unless @connection
          sleep(10)
          refresh_response = Faraday.post(
            "http://#{host}:#{port}/api/v1/authenticate/refresh",
            { refresh_token: refresh_token }
          )
          refresh_result = JSON.parse(refresh_response.body)
          refresh_token = refresh_result['tokens']['refresh_token']

          puts "Refresh token is: #{refresh_token}"
        end

      end
    end

  end
end
