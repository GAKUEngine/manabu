require 'filemagic'
require_relative './resource'
require_relative './guardian'
require_relative './contact'

module Manabu
  class Student < Resource
    class GuardianNotAdded < StandardError; end
    class ContactNotAdded < StandardError; end
    attr_accessor :id, :surname, :name, :name_reading,
                    :surname_reading, :middle_name,
                    :middle_name_reading,:birth_date, :gender, :enrollment_status_code,
                    :contacts

    def initialize(client, **info)
      super
      @contacts = []
    end

    def picture_url
      "#{@client.auth.full_host}#{@picture_path}"
    end

    def picture_thumb_url
      "#{@client.auth.full_host}#{@picture_thumb_path}"
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
      @picture_path = info.fetch(:picture_path, @picture_path)
      @picture_thumb_path = info.fetch(:picture_thumb_path, @picture_thumb_path)
      self
    end

    def set(**info)
      response = @client.patch("students/#{@id}", info)
      fill(response)
    end

    def add_picture(path)
      file = Faraday::UploadIO.new(path, FileMagic.new(FileMagic::MAGIC_MIME).file(path))

      response = @client.patch("students/#{@id}", picture: file)
      fill(response)
    end

    def add_guardian(guardian)
      # NOTE: detect when guardian is already added to student
      response = @client.post("students/#{id}/student_guardians", guardian_id: guardian.id)
      self
    rescue StandardError
      raise GuardianNotAdded, 'Guardian is not added to student'
    end

    def add_contact(contact_type_id, data)
      response = @client.post("students/#{id}/contacts",
        contact_type_id: contact_type_id,
        data: data
      )
      @contacts.push Contact.new(@client, response)
      self
    # rescue StandardError
      # raise ContactNotAdded, 'Contact is not added to student'
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
