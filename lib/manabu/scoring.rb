require_relative './connection/exam_channel'
module Manabu
  class Scoring
    attr_accessor :exam

    def initialize(client, exam, &callback)
      @exam = exam
      @client = client
      @callback = callback

      @live = false
    end

    def start
      @live = true
      channel = Manabu::Connection::ExamChannel.new(@client, exam.id)
      channel.connect do |message|
        _update_score(message)
        @callback.call(message) if @callback && @callback.respond_to?(:call)
      end
    end

    def set_callback(&callback)
      @callback = callback
    end

    def stop
      #NOTE: impelement it. join thread
      @live = false
    end

    def refresh
      exam.portions.each do |portion|
        portion.refresh_portions
      end
    end

    def live?
      @live
    end

    private

    def _update_score(message)
      exam_portion_id = message.fetch('exam_portion_id')
      exam_portion_score_id = message.fetch('id')
      score = message.fetch('score')

      portion = exam.find_portion(exam_portion_id)
      exam_portion_score = portion.find_score(exam_portion_score_id)
      exam_portion_score.score = score
    end

  end
end
