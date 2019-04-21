require_relative 'client'
require_relative 'exam'

module Manabu
  class Exams
    def initialize(client)
      @client = client
      @exams = []
    end

    def all
      return @exams if @exams.any?
      # TODO format object
      response = @client.get('exams')
      @exams = response[:exams].map do |exam|
        Manabu::Exam.new(@client, exam)
      end
    end

  end
end
