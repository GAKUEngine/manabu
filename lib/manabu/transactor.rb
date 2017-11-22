require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'json'
require 'msgpack'
require_relative 'errors'

module Manabu
  class Transactor
    attr_accessor :server_url, :server_port, :transport_type, :status
    def initialize(server_url, server_port = 80, transport_type = :msgpack)
      @server_url = server_url
      @server_port = server_port
      @transport_type = :msgpack
      @status = :unknown
      connect
      _check_server_status
    end

    def connect()
      retrun @connection if @connection
      @connection = Faraday.new do |conn|
        conn.request :url_encoded
        
        case @transport_type
        when :msgpack
          conn.headers['Accept'] = 'application/msgpack'
        when :json
          conn.headers['Accept'] = 'application/json'
        else #someone messed up, defaulting to msgpack
          @transport_type = :msgpack
          conn.headers['Accept'] = 'application/msgpack'
        end

        conn.use FaradayMiddleware::FollowRedirects, limit: 5
        conn.adapter :typhoeus
      end

      _kludge_windows if Gem.win_platform?
      _check_server_status
    end

    # Gets data from the server
    def get(endpoint, *args)
      response = connect.get("#{server_url}:#{server_port}/#{URI.encode(endpoint)}", args)
      _status_raiser(response)
      _datafy_response(response.body)
    end

    # Sets data from the server
    def set(endpoint, *args)
      response = connect.post("#{server_url}:#{server_port}/#{URI.encode(endpoint)}", args)
      _status_raiser(response)
      _datafy_response(response.body)
    end

    def _status_raiser(response)
      case response.status
      when 200..299
        return # don't raise
      else
        fail Error::UnprocessableEntity, response.body
      end
    end

    def _datafy_response(body)
      case @transport_type
      when :msgpack
        return _datafy_msgpack(body)
      when :json
        return _datafy_json(body)
      end

      body # Just return raw data if no transport type was specified...
    end

    def _datafy_msgpack(body)
      begin
        body = MessagePack.unpack(body)
      rescue
        raise Error::InvalidMsgPack, 'Malformed data from server!'
      end

      data
    end

    def _datafy_json(body)
      begin
        data = JSON.parse(body, symbolize_names: true)
      rescue JSON::ParseError
        raise Error::InvalidJSON, 'Malformed data from server!'
      end

      data
    end

    def _check_server_status
      get('status'
    end

    # Windows doesn't supply us with the correct cacert.pem, so we force it
    def _kludge_windows
      cert_loc = "#{__dir__}/cacert.pem"
      unless File.exist? cert_loc
        response = @@connection.get('http://curl.haxx.se/ca/cacert.pem')
        File.open(cert_loc, 'wb') { |fp| fp.write(response.body) }
      end
      ENV['SSL_CERT_FILE'] = cert_loc
    end
  end
end
