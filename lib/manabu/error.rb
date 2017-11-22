module Manabu
  module Error
    class Unauthorized < SecurityError; end
    class UnprocessableEntity < StandardError; end
    class InvalidJSON < StandardError; end
    class InvalidMsgPack < StandardError; end
  end
end
