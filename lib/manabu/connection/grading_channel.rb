
require 'websocket-client-simple'
module Manabu
  module Connection
    class GradingChannel
      attr_accessor  :exam, :enqueue, :message

      def initialize(client, exam)
        @client = client
        @e: context.exam}.to_json
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
