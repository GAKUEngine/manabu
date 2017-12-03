require_relative 'client'

module Manabu
  class Students
    def initialize(client)
      @client = client
    end

    def index
      @client.get('students')
      # TODO format object
    end

   # def create(attributes = {})
   #   @client.post('students', student: attributes)
   # end

   # def update(id, attributes = {})
   #   @client.patch("students/#{id}", student: attributes)
   # end

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
