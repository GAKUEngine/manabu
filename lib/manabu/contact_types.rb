module Manabu
  class ContactTypes
    attr_accessor :client

    def initialize(client)
      @client = client
      @contact_types = {}
    end

    def register(name)
      response = @client.post("/contact_types", name: name)
      response[:id]
    rescue
      nil
    end

    def all
      return @contact_types unless @contact_types.empty?

      response = @client.get("/contact_types")
      @contact_types = response[:contact_types].each_with_object({}) do |type, obj|
        obj[type[:name]] = type[:id]
      end
    end
  end
end
