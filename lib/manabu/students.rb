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
     # NOTE: cache results
      return students if filters.empty?

      students.select do |student|
        filters.slice(*whitelist_filter_attributes).all? do |filter, value|
          student.send(filter) == value
        end
      end
    end

    def filter(conditions = {})
      result = students.dup

      conditions.each do |name, value|
        case name
        when :enrollment_status
          result.select! do |student|
            student.enrollment_status_code == value
          end
        end
      end

      result
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
     # NOTE: check in response when implement error object
     true
   end

    private

    def students()
      if @students.any?
        @students
      else
        @students = _fetch_students
      end
    end

    def whitelist_filter_attributes
      [:id, :name, :surname]
    end

    def _fetch_students()
      # TODO raise error if @client is nil
      response = @client.get('students')
      response[:students].map do |student|
        Manabu::Student.new(@client, student)
      end
    end

  end
end
