require_relative 'client'

module Manabu
  class Courses
    def initialize(client)
      @client = client
    end

    def index
      # TODO format object
      @client.get('courses')
    end

   def register(attributes = {})
     @client.post('courses', attributes)
   end

    # def register(attributes = {})
    # end

    # def get(id)
    # end

    # def delete(id)
    # end
  end
end
