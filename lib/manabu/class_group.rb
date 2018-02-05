module Manabu
  class ClassGroup < Resource

    class Enrollment

      def initialize(client, attributes = {})
        @client = client
        @id = attributes.fetch(:id, @id)
        @class_group_id = attributes.fetch(:class_group_id, @class_group_id)
        @student_id = attributes.fetch(:student_id, @student_id)
        @student = nil
      end

      def student
        if @student
          @student
        else
          @student = _fetch_student
        end
      end

      private

      def _fetch_student
        response = @client.get("students/#{@student_id}")
        Manabu::Student.new(@client, response)
      end
    end

    attr_reader :id, :name, :grade, :homeroom, :notes_count,
      :enrollments_count, :facility_id

    def initialize(client, **info)
      super
      @students = []
      @enrollments = []
    end

    def fill(**info)
      @id = info.fetch(:id, @id)
      @name = info.fetch(:name, @name)
      @grade = info.fetch(:grade, @grade)
      @homeroom = info.fetch(:homeroom, @homeroom)
      @notes_count = info.fetch(:notes_count, @notes_count)
      @enrollments_count = info.fetch(:enrollments_count, @enrollments_count)
      @facility_id = info.fetch(:facility_id, @facility_id)
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
      response = @client.post("class_groups/#{id}/enrollments",
        student_id: student.id
      )

      Enrollment.new(@client, response).tap do |enrollment|
        @enrollments << enrollment
      end
    end

    private

    def _fetch_students
      response = @client.get("class_groups/#{id}/students")
      response[:students].map do |student|
        Manabu::Student.new(@client, student)
      end
    end

    def _fetch_enrollments
      response = @client.get("class_groups/#{id}/enrollments")
      response[:enrollments].map do |enrollment|
        Enrollment.new(@client, enrollment)
      end
    end

  end
end
