require_relative './connection/grading_channel'
module Manabu
  class Grading
    attr_accessor :exam

    def initialize(client, exam, &callback)
      @exam = exam
      @client = client
      @callback = callback

      @live = false
    end

    def start
      @live = true
      channel = Manabu::Connection::GradingChannel.new(@client, exam.id)
      channel.connect do |message|
        puts message.inspect
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

  end
end
