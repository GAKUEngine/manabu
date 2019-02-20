require_relative './resource'

module Manabu
  class Guardian < Resource
    class ContactNotAdded < StandardError; end

    attr_accessor :id, :surname, :name, :name_reading, :surname_reading, :birth_date, :gender

    def initialize(client, **info)
      super
      @contacts = []
    end

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

    def add_contact(contact_type_id, data)
      response = @client.post("guardians/#{id}/contacts",
        contact_type_id: contact_type_id,
        data: data
      )
      @contacts.push Contact.new(@client, response)
      self
    rescue StandardError
      raise ContactNotAdded, 'Contact is not added to student'
    end

  end
end
