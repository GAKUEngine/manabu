require_relative 'resource'
require_relative 'exam_portion'
require_relative 'connection/exam_channel'

module Manabu
  class Exam < Resource
    attr_reader :id, :name

    def fill(**info)
      @id = info.fetch(:id, @id)
      @name = info.fetch(:name, @name)
      @portions = []

      self
      @live = false
    end

    def enable_websocket
      @live = true
      _initialize_websocket
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

    def websocket_enabled?
      @live
    end

    private

    def _initialize_websocket
      channel = Manabu::Connection::ExamChannel.new(@client, id)
      channel.connect do |message|
        portion = find_portion(message['exam_portion_id'])
        score = portion.find_score(message['id'])
        score.score = message['score']
      end
    end

    def _fetch_exam_portions
      response = @client.get("exams/#{id}/exam_portions")
      response[:exam_portions].map do |exam_portion|
        Manabu::ExamPortion.new(@client, exam_portion.merge(exam: self))
      end
    end

  end
end
