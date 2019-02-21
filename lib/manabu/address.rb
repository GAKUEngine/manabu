require_relative './resource'

module Manabu
  class Address < Resource
    attr_accessor :id, :address1, :address2, :zipcode, :state, :country_id, :city

    def fill(**info)
      @id = info.fetch(:id, @id)
      @address1 = info.fetch(:address1, @address1)
      @address2 = info.fetch(:address2, @address2)
      @zipcode = info.fetch(:zipcode, @zipcode)
      @state = info.fetch(:state, @state)
      @country_id = info.fetch(:country_id, @country_id)
      @city = info.fetch(:city, @city)
      self
    end

  end
end
