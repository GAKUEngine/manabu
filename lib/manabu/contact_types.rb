require_relative './contact_type'
module Manabu
  class ContactTypes
    attr_accessor :client

    def initialize(client)
      @client = client
      @contact_types = []
    end

    def register(name)
      response = @client.post("/contact_types", name: name)
      contact_type = Manabu::ContactType.new(client, response)
      @contact_types << contact_type
      contact_type
    rescue
      nil
    end

    def all
      return @contact_types unless @contact_types.empty?

      response = @client.get("/contact_types")
      @roles =  response[:contact_types].map do |contact_type|
        Manabu::ContactType.new(@client, contact_type)
      end

      # @contact_types = response[:contact_types].each_with_object({}) do |type, obj|
      #   obj[type[:name]] = type[:id]
      # end
    end
  end
end
