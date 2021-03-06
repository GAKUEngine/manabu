require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'json'
require 'msgpack'
require_relative 'error'

module Manabu
  module Connection
    # Handles transactions between server, abstracting the transport protocol and returning objects
    class Transactor
      attr_accessor :server_url, :server_port, :transport_type, :force_secure_connection, :status,
                    :api_version, :authorization

      def initialize(server_url, server_port = 80, force_secure_connection = true,
                     transport_type = :msgpack, **options)
        @server_url = server_url
        @server_port = server_port
        @transport_type = transport_type
        @status = :unknown
        @force_secure_connection = force_secure_connection
        @options = options
        @api_version = options.fetch(:api_version, 1)
        connect
        _check_server_status
      end

      def connect()
        return @connection if @connection
        @connection = Faraday.new do |conn|
          conn.request :multipart
          conn.request :url_encoded

          case @transport_type
          when :msgpack
            conn.headers['Accept'] = 'application/msgpack'
          when :json
            conn.headers['Accept'] = 'application/json'
          else # someone messed up, defaulting to msgpack
            @transport_type = :msgpack
            conn.headers['Accept'] = 'application/msgpack'
          end

          conn.use FaradayMiddleware::FollowRedirects, limit: 5
          conn.adapter :typhoeus
        end

        _kludge_windows if Gem.win_platform?

        _check_server_status
      end

      def simple_get(endpoint)
        Faraday.get("#{full_host}/api/v#{@api_version}/#{endpoint}")
      end

      # Gets data from the server
      def get(endpoint, **args)
        _define_action(:get, endpoint, args)
      end

      # Sets data from the server
      def post(endpoint, **args)
        _define_action(:post, endpoint, args)
      end

      def patch(endpoint, **args)
        _define_action(:patch, endpoint, args)
      end

      def delete(endpoint, **args)
        _define_action(:delete, endpoint, args)
      end

      def full_host
        "#{@protocol}://#{@server_url}:#{@server_port}"
      end

      def _define_action(action, endpoint, args)
        response = connect.send(
          action,
          URI.encode(
            "#{full_host}/api/v#{@api_version}/#{endpoint}"),
            args,
            _header_hash
          )
        _status_raiser(response)
        _datafy_response(response.body)
      end

      def _header_hash
        Hash.new.tap do |h|
          h['Authorization'] = authorization if authorization
        end
      end


      def _status_raiser(response)
        case response.status
        when 200..299
          return # don't raise
        else
          case @transport_type
          when :msgpack
            raise Error::UnprocessableEntity, _datafy_msgpack(response.body)
          when :json
            raise Error::UnprocessableEntity, _datafy_json(response.body)
          end
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
        MessagePack::DefaultFactory.register_type(0x00, Symbol)
        MessagePack.unpack(body, symbolize_keys: true)
      rescue
        raise Manabu::Connection::Error::InvalidMsgPack, 'Malformed data from server!'
      end

      def _datafy_json(body)
        JSON.parse(body, symbolize_names: true)
      rescue JSON::ParseError
        raise Manabu::Connection::Error::InvalidJSON, 'Malformed data from server!'
      end

      def _check_server_status
        @protocol = 'https'
        @status = get('status')[:status]
      rescue Faraday::ConnectionFailed
        unless @force_secure_connection
          @protocol = 'http'
          @status = get('status')[:status]
        end
      end

      # Windows doesn't supply us with the correct cacert.pem, so we force it
      def _kludge_windows
        cert_loc = "#{__dir__}/cacert.pem"
        unless File.exist? cert_loc
          response = @connection.get('http://curl.haxx.se/ca/cacert.pem')
          File.open(cert_loc, 'wb') { |fp| fp.write(response.body) }
        end
        ENV['SSL_CERT_FILE'] = cert_loc
      end
    end
  end
end
