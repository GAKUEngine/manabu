require 'spec_helper'
require 'manabu/contact_types'

describe Manabu::ContactTypes do
  let(:client) { Manabu::Client.new('admin', 123456, 'localhost', 9000, force_secure_connection: false) }
  let(:contact_types) { Manabu::ContactTypes.new(client) }

  context 'types' do
    it 'return all types as hash' do
      expect(contact_types.all).to include({"email" => 1})
    end
  end

  context 'register' do

    it 'create new contact type' do
      response = contact_types.register("mobile")
      expect(response).to be_integer

    end

    it 'return nil if exists' do
      response = contact_types.register("email")
      expect(response).to be_nil
    end

  end
end
