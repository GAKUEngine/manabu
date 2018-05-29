require_relative 'role'
module Manabu
  class Roles
    attr_accessor :client

    def initialize(client)
      @client = client
      @roles = []
    end

    def all
      return @roles unless @roles.empty?

      response = @client.get("/roles")
      @roles =  response[:roles].map do |role|
        Manabu::Role.new(@client, role)
      end
    end
  end
end
