require 'websocket-client-simple'
module Manabu
  module Connection
    class ExamChannel
      attr_accessor :exam, :enqueue, :message

      def initialize(client, exam)
        @client = client
        @enqueue = []
        @exam = exam
      end

      # private

      def connect(&block)
        context = self
        connect_block = block
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

              block.call(data['message']) if data.has_key?('identifier')
            end
          end
        end

    end
  end
end
