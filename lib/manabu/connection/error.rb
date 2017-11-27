module Manabu
  module Connection
    module Error
      class Unauthorized < RuntimeError; end
      class UnprocessableEntity < StandardError; end
      class InvalidJSON < StandardError; end
      class InvalidMsgPack < StandardError; end
    end
  end
end
