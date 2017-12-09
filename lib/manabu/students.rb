require_relative 'client'
require_relative 'student'

module Manabu
  class Students
    def initialize(client)
      @client = client
    end

    def roster(**filters)
      res = @client.get('students', filters)
      # TODO: handle errors
      # TODO: return results as an array of Student object instances
    end

    def register(student)
      case student
      when Manabu::Student
        return register_student_by_object(student)
      when Hash
        return register_student_by_hash(student)
      end
    end

    def register_student_by_object(student)
      res = @client.post('students', student.to_hash)
      # TODO: handle errors
      student.fill(res)
    end

    def register_student_by_hash(student)
      res = @client.post('students', student)
      # TODO: handle errors
      Manabu::Student.new(@client, res)
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
