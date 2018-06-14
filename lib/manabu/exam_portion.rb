require_relative 'resource'
require_relative 'exam_portion_score'

module Manabu
  class ExamPortion < Resource
    attr_reader :id, :name, :exam_id, :exam

    def fill(**info)
      @id = info.fetch(:id, @id)
      @name = info.fetch(:name, @name)
      @max_score = info.fetch(:max_score, @max_score)
      @exam_id = info.fetch(:exam_id, @exam_id)
      @exam = info.fetch(:exam, @exam)
      @scores = []
      self
    end

    def find_score(id)
      scores.find do |score|
        score.id == id
      end
    end

    def scores
      if @scores.any?
        @scores
      else
        @scores = _fetch_exam_portion_scores
      end
    end

    private

    def _fetch_exam_portion_scores
      response = @client.get("exams/#{exam_id}/exam_portions/#{id}/exam_portion_scores")
      response[:exam_portion_scores].map do |exam_portion_score|
        Manabu::ExamPortionScore.new(@client, exam_portion_score.merge(portion: self))
      end
    end
  end
end
