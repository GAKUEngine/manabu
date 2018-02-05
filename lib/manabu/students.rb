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
      @students = []
    end

    # Returns a roster of all students which the client user has access to.
    #
    # == Parameters:
    # filters:
    #  A hash of filters to narrow down results. Available filters include:
    #  * enrollment_status - [] TODO fill in enrollment statuses
    def roster(**filters)
       # TODO: handle errors
       # TODO: handle filters in API endpoint
      filters_hash = build_filters(filters)
      response = @client.get('students', q: filters_hash)
      @students = response[:students].map do |student|
        Manabu::Student.new(@client, student)
      end
    end

    def register(student)
      new_student = case student
      when Manabu::Student
        register_student_by_object(student)
      when Hash
        register_student_by_hash(student)
      end
      new_student.tap { |object| @students << object }
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

   def delete(student)
     @client.delete("students/#{student.id}")
     @students.reject! { |object| object.id == student.id }
     # NOTE: check in response
     true
   end

    private

    def build_filters(filters)
     {
       enrollment_status_code_eq: filters[:enrollment_status]
     }.compact
    end

  end
end
