module Manabu
  # General client interface which bundles together most client functionality
  class Client
    attr_accessor :Auth
    def initialize(options = {})
      @Auth = Manabu::Auth.new(options)
    end

    def login(username, password)
      Auth.login(username, password)
    end
  end
end
