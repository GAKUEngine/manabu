module Manabu
  module Student
    class Courses

      attr_accessor :transactor, :student_id

      def initialize(transactor, student_id)
        @transactor = transactor
        @student_id = student_id
      end

      def index
        transactor.get("v1/students/#{student_id}/courses")
      end
    end
  end
end
