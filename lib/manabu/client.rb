require_relative 'connection/auth'
require_relative 'connection/transactor'

module Manabu
  # General client interface which bundles together most client functionality
  class Client
    attr_accessor :auth, :transactor, :status

    # Initializes with login details and passes options to all linked instances.
    #
    # == Parameters:
    # username::
    #  The User Name or e-mail address
    # password::
    #  The password for the given user
    # host::
    #  The host URL
    # port::
    #  The host port (default 80)
    # options::
    #  A hash of options, such as:
    #  * force_secure_connection - (default true), set to false to disable HTTPS/SSL
    #  * transport_type - (default :msgpack), sets transport data type [:msgpack, :json]
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
    #
    # == Parameters:
    # path::
    #  The API endpoint path
    # args::
    #  An argument hash
    #
    # == Returns:
    #  The returned data as an object
    def get(path, **args)
      @transactor.get(path, args)
    end

    # Performs a POST against the API
    #
    # == Parameters:
    # path::
    #  The API endpoint path
    # args::
    #  An argument hash
    #
    # == Returns:
    #  The returned data as an object
    def post(path, **args)
      @transactor.post(path, args)
    end

    # Performs a PATCH against the API
    #
    # == Parameters:
    # path::
    #  The API endpoint path
    # args::
    #  An argument hash
    #
    # == Returns:
    #  The returned data as an object
    def patch(path, **args)
      @transactor.patch(path, args)
    end

    # Performs a DELETE against the API
    #
    # == Parameters:
    # path::
    #  The API endpoint path
    # args::
    #  An argument hash
    #
    # == Returns:
    #  The returned data as an object
    def delete(path, **args)
      @transactor.delete(path, args)
    end

    # def inspect
    #   "#<Manabu::Client:#{object_id}>"
    # end
  end
end
