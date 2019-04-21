require_relative 'resource'
require_relative 'role'
module Manabu
  class Syllabus < Resource

    attr_reader :id, :name, :code

    def fill(**info)
      @id = info.fetch(:id, @id)
      @name = info.fetch(:name, @name)
      @code = info.fetch(:code, @code)
      self
    end

    # NOTE: should cache exams
    def exams
      response = @client.get("syllabuses/#{id}/exams")
      response[:exams].map do |exam|
        Manabu::Exam.new(@client, exam)
      end
    end

    # NOTE: should cache courses
    def courses
      response = @client.get("syllabuses/#{id}/courses")
      response[:courses].map do |course|
        Manabu::Course.new(@client, course)
      end
    end

  end
end
