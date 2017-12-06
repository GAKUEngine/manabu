require_relative 'client'

module Manabu
  class Syllabuses
    def initialize(client)
      @client = client
    end

    def index
      # TODO format object
      @client.get('syllabuses')
    end

   def register(attributes = {})
     @client.post('syllabuses', attributes)
   end

  end
end
