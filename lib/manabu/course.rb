module Manabu
  class Course < Resource

    class Enrollment

      def initialize(client, student_id, seat_number)
        @client = client
        @student_id = student_id
        @seat_number = seat_number
      end

      def student
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
        _fetch_enrollments
      end
    end

    def add_student(student, args = {})
      response = @client.post("courses/#{id}/enrollments",
        student_id: student.id,
        seat_number: args[:seat_number]
      )

      Enrollment.new(@client, *response.values_at(:student_id, :seat_number)).tap do |enrollment|
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
        Enrollment.new(@client, enrollment[:student_id], enrollment[:seat_number])
      end
    end

  end
end
