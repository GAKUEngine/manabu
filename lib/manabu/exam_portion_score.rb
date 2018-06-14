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
      response = @client.patch("students/#{@id}", info)
      fill(response)
    end
  end
end
