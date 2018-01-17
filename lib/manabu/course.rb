module Manabu
  class Course < Resource

    class Enrollment

      attr_reader :seat_number

      def initialize(client, attributes = {})
        @client = client
        @id = attributes.fetch(:id, @id)
        @course_id = attributes.fetch(:course_id, @course_id)
        @student_id = attributes.fetch(:student_id, @student_id)
        @seat_number = attributes.fetch(:seat_number, @seat_number)
        @student = nil
      end

      def student
        if @student
          @student
        else
          @student = _fetch_student
        end
      end

      def seat_number=(value)
        # TODO: handle when seat is occupied by another student
        # TODO: handle other errors (EG request was invalid, request timed out)
        response = @client.patch("courses/#{@course_id}/enrollments/#{@id}", seat_number: value)
        @seat_number = value
      end

      private

      def _fetch_student
        response = @client.get("students/#{@student_id}")
        Manabu::Student.new(@client, response)
      end
    end

    attr_reader :id, :name, :code, :notes_count, :students_count,
      :enrollments_count, :facility_id, :syllbaus_id

    def initialize(client, **info)
      super
      @students = []
      @enrollments = []
    end

    def fill(**info)
      @id = info.fetch(:id, @id)
      @name = info.fetch(:name, @name)
      @code = info.fetch(:code, @code)
      @notes_count = info.fetch(:notes_count, @notes_count)
      @students_count = info.fetch(:students_count, @students_count)
      @enrollments_count = info.fetch(:enrollments_count, @enrollments_count)
      @facility_id = info.fetch(:facility_id, @facility_id)
      @syllabus_id = info.fetch(:syllabus_id, @syllabus_id)
      self
    end

    def students
      if @students.any?
        @students
      else
        @students = _fetch_students
      end
    end

    def enrollments
      if @enrollments.any?
        @enrollments
      else
        @enrollments = _fetch_enrollments
      end
    end

    def add_student(student, args = {})
      response = @client.post("courses/#{id}/enrollments",
        student_id: student.id,
        seat_number: args[:seat_number]
      )

      Enrollment.new(@client, response).tap do |enrollment|
        @enrollments << enrollment
      end
    end

    private

    def _fetch_students
      response = @client.get("courses/#{id}/students")
      response[:students].map do |student|
        Manabu::Student.new(@client, student)
      end
    end

    def _fetch_enrollments
      response = @client.get("courses/#{id}/enrollments")
      response[:enrollments].map do |enrollment|
        Enrollment.new(@client, enrollment)
      end
    end

  end
end
