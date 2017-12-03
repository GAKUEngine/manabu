require_relative 'client'

module Manabu
  class Courses
    def initialize(client)
      @client = client
    end

    def index(filters = {})
      puts @client.get('courses')
    end

    # def register(attributes = {})
    # end

    # def get(id)
    # end

    # def delete(id)
    # end
  end
end
