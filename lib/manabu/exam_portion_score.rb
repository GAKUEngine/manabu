require_relative './resource'

module Manabu
  class ExamPortionScore < Resource
    attr_reader :id, :portion
    attr_accessor :score

    def fill(**info)
      @id = info.fetch(:id, @id)
      @score = info.fetch(:score, @score)
      @portion = info.fetch(:portion, @portion)
      self
    end

    def set(**info)
      response = @client.patch("exam_portion_scores/#{@id}", info)
      fill(response)
    end
  end
end
