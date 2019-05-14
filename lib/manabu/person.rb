module Manabu
  class Person < Resource

    def initialize(client, **info)
      super
      @addresses = nil
      @contacts = nil
      @picture = nil
    end

    def addresses
      if @addresses.nil?
        @addresses = _fetch_addresses
      else
        @addresses
      end
    end

    def contacts
      if @contacts.nil?
        @contacts = _fetch_contacts
      else
        @contacts
      end
    end

    def add_contact(contact)
      contacts

      response = @client.post("students/#{id}/contacts",
                              contact_type_id: contact.contact_type.id,
                              data: contact.data
                             )
      Contact.new(@client, response).tap do |new_contact|
        contacts.push(new_contact)
      end
    rescue StandardError
      raise ContactNotAdded, "Contact is not added to #{self.class::SINGULAR}"
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
      Address.new(@client, response).tap do |new_address|
        addresses.push(new_address)
      end
    rescue StandardError
      raise AddressNotAdded, "Address is not added to #{self.class::SINGULAR}"
    end

    private

    def _fetch_addresses
      response = @client.get("#{self.class::PLURAL}/#{id}/addresses")
      response[:addresses].map do |address|
        Manabu::Address.new(@client, address)
      end
    end

    def _fetch_contacts
      response = @client.get("#{self.class::PLURAL}/#{id}/contacts")
      response[:contacts].map do |contact|
        Manabu::Contact.new(@client, contact)
      end
    end

  end
end
