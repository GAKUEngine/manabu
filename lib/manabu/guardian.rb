require_relative './resource'
require_relative './person'

module Manabu
  class Guardian < Person
    PLURAL= 'guardians'.freeze
    SINGULAR = 'guardian'.freeze

    class ContactNotAdded < StandardError; end
    class AddressNotAdded < StandardError; end

    attr_accessor :id, :surname, :name, :name_reading, :surname_reading, :birth_date, :gender

    def fill(**info)
      @id = info.fetch(:id, @id)
      @surname = info.fetch(:surname, @surname)
      @name = info.fetch(:name, @name)
      @name_reading = info.fetch(:name_reading, @name_reading)
      @surname_reading = info.fetch(:surname_reading, @surname_reading)
      @birth_date = info.fetch(:birth_date, @birth_date)
      @gender = info.fetch(:gender, @gender)

      self
    end

    def add_contact(contact_type, data)
      response = @client.post("guardians/#{id}/contacts",
        contact_type_id: contact_type.id,
        data: data
      )
      @contacts.push Contact.new(@client, response)
      self
    rescue StandardError
      raise ContactNotAdded, 'Contact is not added to student'
    end

    def add_address(address)
      response =
        @client.post("guardians/#{id}/addresses",
          address1: address.address1,
          address2: address.address2,
          zipcode: address.zipcode,
          state: address.state,
          country_id: address.country_id,
          city: address.city
        )
      self
    rescue StandardError
      raise AddressNotAdded, 'Address is not added to student'
    end

  end
end
