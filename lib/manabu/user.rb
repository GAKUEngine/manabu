require_relative 'resource'
require_relative 'role'
module Manabu
  class User < Resource


    attr_reader :id, :username, :email, :roles, :disabled, :disabled_until

    def fill(**info)
      @id = info.fetch(:id, @id)
      @username = info.fetch(:username, @username)
      @email = info.fetch(:email, @email)
      @disabled = info.fetch(:disabled, @disabled)
      @disabled_until = info.fetch(:disabled_until, @disabled_until)
      @roles = info[:roles].map {|role| Manabu::Role.new(@client, role)}
      self
    end

    def add_role(role)
      response = @client.post("users/#{id}/user_roles", role_id: role.id)
      binding.pry
      @roles << Manabu::Role.new(@client, response)
      self
    end

    def disabled?
      return false if disabled.nil? && disabled_until.nil?

      if disabled_until
        disabled_until > Date.today
      else
        disabled
      end
    end

    def set(**info)
      response = @client.patch("users/#{@id}", info)
      fill(response)
    end

  end
end
