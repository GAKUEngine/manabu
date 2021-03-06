require 'manabu/student'
require 'manabu/students'
require 'manabu/contact_types'
require 'date'
describe Manabu::Students do

  let(:client) {  Manabu::Client.new('admin', '123456', 'localhost', 9000,
                                  force_secure_connection: false) }

  context '.new' do
    it 'creates a blank Student template' do
      student = Manabu::Student.new(client)
      expect(student.name).to be(nil)
      expect(student.id).to be(nil)
    end

    it 'fills student object attrs with an initializing hash' do
      student = Manabu::Student.new(client, name: 'a', surname: 'b')
      expect(student.name).to eq('a')
      expect(student.id).to be(nil)
    end
  end

  context '.fill' do
    it 'fills details by lambda' do
      student = Manabu::Student.new(client)
      expect(student.name).to eq(nil)
      expect(student.id).to eq(nil)

      student.fill(id: 0)
      expect(student.name).to eq(nil)
      expect(student.id).to eq(0)

      student.fill(name: 'test')
      expect(student.name).to eq('test')
      expect(student.id).to eq(0)
    end
  end

  context '.set' do
    it 'change student attribute' do
      # setup
      student = Manabu::Students.new(client)
        .register(name: 'test', surname: 'testov', birth_date: Date.today)
      expect(student.id).to_not be_nil

      # excercise
      student.set(name: 'ruby')

      # verify
      expect(student.name).to eq 'ruby'


      # teardown
      # will add it when implement destroy student
    end
  end

  context '.add_contact' do
    it 'creates new contact' do
      contact_type_id = Manabu::ContactTypes.new(client).register('something')


      student = Manabu::Students.new(client)
        .register(name: 'test', surname: 'testov', birth_date: Date.today)

      student.add_contact(contact_type_id, "089912341234")

      expect(student.contacts.length).to_not eq 0

      contact = student.contacts.first

      expect(contact.data).to eq '089912341234'

    end
  end
end
