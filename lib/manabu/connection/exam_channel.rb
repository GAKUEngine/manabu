require 'websocket-client-simple'
module Manabu
  module Connection
    class ExamChannel
      attr_accessor :exam
      ExamPortionScore = Struct.new(:id, :score)

      attr_accessor :enqueue, :message

      def initialize(client, exam)
        @client = client
        @enqueue = []
        @exam = exam
      end

      # private

      def connect(&block)
        context = self
        token = @client.transactor.authorization

        ws = WebSocket::Client::Simple.connect "ws://localhost:9000/api/v1/cable?auth_token=#{token}"

        ws.on :open do
          msg = {
            command: 'subscribe',
            identifier: { channel: 'ApplicationCable::ExamChannel', exam_id: context.exam}.to_json
          }.to_json
          ws.send msg
        end

        thread = Thread.new do
            channel = self
            ws.on :message do |msg|
              data = JSON.parse msg.data
              puts data
              if data && data['identifier']
                # puts JSON.parse(data).inspect
                if JSON.parse(data['identifier']) == { "channel" => "ApplicationCable::ExamChannel", "exam_id" => @exam }
                  message = data['message']
                  unless message.nil?
                    # block.call(ExamPortionScore.new(message["id"], message['score']))
                    block.call(message)
                    # channel.enqueue.push ExamPortionScore.new(message["id"], message['score'])
                  end
                end
              end
            end
          end
        end

    end
  end
end
