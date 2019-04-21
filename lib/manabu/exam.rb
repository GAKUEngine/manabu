require_relative 'resource'
require_relative 'exam_portion'
require_relative 'scoring'
require_relative 'grading'

module Manabu
  class Exam < Resource
    attr_reader :id, :name, :scoring, :grading

    def fill(**info)
      @id = info.fetch(:id, @id)
      @name = info.fetch(:name, @name)
      @portions = []

      @scoring = Manabu::Scoring.new(@client, self)
      # @grading = Manabu::Grading.new(@client, self)

      self
    end

    def find_portion(id)
      portions.find do |portion|
        portion.id == id
      end
    end

    def portions
      if @portions.any?
        @portions
      else
        @portions = _fetch_exam_portions
      end
    end

    private

    def _fetch_exam_portions
      response = @client.get("exams/#{id}/exam_portions")
      response[:exam_portions].map do |exam_portion|
        Manabu::ExamPortion.new(@client, exam_portion.merge(exam: self))
      end
    end

  end
end
