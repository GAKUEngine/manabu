require_relative 'client'
require_relative 'student'

module Manabu
  # Handles the student index for the given client
  class Students

    # Initializes against the passed client instance. If the client instance does not 
    # contain a client with a valid authorization all methods will return nil.
    #
    # == Parameters:
    # client::
    #  A Manabu::Client instance (with a valid authorization)
    def initialize(client)
      @client = client
    end

    # Returns a roster of all students which the client user has access to.
    # 
    # == Parameters:
    # filters:
    #  A hash of filters to narrow down results. Available filters include:
    #  * enrollment_status - [] TODO fill in enrollment statuses
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
