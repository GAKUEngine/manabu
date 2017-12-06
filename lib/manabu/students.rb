require_relative 'client'

module Manabu
  class Students
    def initialize(client)
      @client = client
    end

    def index
      # TODO format object
      @client.get('students')
    end

   def register(attributes = {})
     @client.post('students', attributes)
   end

   # def update(id, attributes = {})
   #   @client.patch("students/#{id}", student: attributes)
   # end
    # def register(attributes = {})

   # def show(id)
   #   @client.get("students/#{id}")
   # end

   # def destroy(id)
   #   @client.delete("students/#{id}")
   # end

   # def courses(id)
   #   Manabu::Student::Courses.new(transactor, id)
   # end
  end
end
