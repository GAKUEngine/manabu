require_relative 'client'

module Manabu
  class Users
    def initialize(client)
      @client = client
      @users = []
    end

    def all
      # TODO format object
      response = @client.get('users')

      @users = response[:users].map do |user|
        Manabu::User.new(@client, user)
      end
    end

    # NOTE: add auto generated password and notify password with condition
    def register(user)
      case user
      when Manabu::User
        return register_user_by_object(user)
      when Hash
        return register_user_by_hash(user)
      end
    end

    def register_user_by_object(user)
      res = @client.post('users', user.to_hash)
      # TODO: handle errors
      user.fill(res)
    end

    def register_user_by_hash(user)
      res = @client.post('users', user)
      # TODO: handle errors
      Manabu::User.new(@client, res)
    end
  end
end
