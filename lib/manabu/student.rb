require 'mimemagic'
require_relative './resource'
require_relative './guardian'
require_relative './enrollment_status'
require_relative './contact'

module Manabu
  class Student < Resource
    class GuardianNotAdded < StandardError; end
    class ContactNotAdded < StandardError; end
    class AddressNotAdded < StandardError; end
    attr_accessor :id, :surname, :name, :name_reading,
                    :surname_reading, :middle_name,
                    :middle_name_reading,:birth_date, :gender, :enrollment_status,
                    :contacts, :enrollment_status_code

    def initialize(client, **info)
      super
      @contacts = []
      @picture = nil
    end

    def fill(**info)
      @id = info.fetch(:id, @id)
      @surname = info.fetch(:surname, @surname)
      @name = info.fetch(:name, @name)
      @name_reading = info.fetch(:name_reading, @name_reading)
      @surname_reading = info.fetch(:surname_reading, @surname_reading)
      @birth_date = info.fetch(:birth_date, @birth_date)
      @gender = info.fetch(:gender, @gender)
      @enrollment_status_code = info.fetch(:enrollment_status_code, @enrollment_status_code)
      @enrollment_status = Manabu::EnrollmentStatus.new(@client, info[:enrollment_status] || {})
      self
    end

    def picture
      return unless @id
      return @picture if @picture

      response = @client.simple_get("students/#{id}/picture")
      @picture = response.body
    end

    def set(**info)
      response = @client.patch("students/#{@id}", info)
      fill(response)
    end

    def add_picture(path)
      file_mimetype = MimeMagic.by_path(path)
      file = Faraday::UploadIO.new(path, file_mimetype)

      response = @client.patch("students/#{@id}", picture: file)
      @picture = nil
      fill(response)
    end

    def add_guardian(guardian)
      # NOTE: detect when guardian is already added to student
      response = @client.post("students/#{id}/student_guardians", guardian_id: guardian.id)
      self
    rescue StandardError
      raise GuardianNotAdded, 'Guardian is not added to student'
    end

    def add_contact(contact_type, data)
      response = @client.post("students/#{id}/contacts",
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
        @client.post("students/#{id}/addresses",
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

    def guardians
      response = @client.get("students/#{id}/guardians")
      response[:guardians].map do |guardian|
        Manabu::Guardian.new(@client, guardian)
      end
    end

    def courses
      response = @client.get("students/#{id}/courses")
      response[:courses].map do |course|
        Manabu::Course.new(@client, course)
      end
    end
  end
end
