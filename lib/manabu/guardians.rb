require_relative 'client'
require_relative 'guardian'

module Manabu
  class Guardians
    def initialize(client)
      @client = client
      @guardians = []
    end


    def register(guardian)
      new_guardian = case guardian
      when Manabu::Student
        register_guardian_by_object(guardian)
      when Hash
        register_guardian_by_hash(guardian)
      end
      new_guardian.tap { |object| @guardians << object }
    end

    def register_guardian_by_object(guardian)
      res = @client.post('guardians', guardian.to_hash)
      # TODO: handle errors
      guardian.fill(res)
    end

    def register_guardian_by_hash(guardian)
      res = @client.post('guardians', guardian)
      # TODO: handle errors
      Manabu::Guardian.new(@client, res)
    end


    def guardians()
      if @guardians.any?
        @guardians
      else
        @guardians = _fetch_guardians
      end
    end

    private

    def _fetch_guardians()
      # TODO raise error if @client is nil
      response = @client.get('guardians')
      response[:guardians].map do |guardian|
        Manabu::Guardian.new(@client, guardian)
      end
    end

  end
end
