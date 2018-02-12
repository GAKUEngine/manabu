require 'manabu/students'

describe Manabu::Students do
  context '.roster' do
    it 'Obtiains the student roster, without fitlers' do
      client = Manabu::Client.new('admin', 123456, 'localhost', 9000,
                                  force_secure_connection: false)
      students = Manabu::Students.new(client)
      student_hash = { name: 'test', surname: 'test' }

      response = students.register(student_hash)
      expect(response).to be_kind_of(Manabu::Student)
      expect(students.roster).to eq [response]

      students.delete(response)
    end

    it 'Obtiains the student roster with name filter' do
      client = Manabu::Client.new('admin', 123456, 'localhost', 9000,
                                  force_secure_connection: false)
      students = Manabu::Students.new(client)
      student_hash = { name: 'test', surname: 'test' }

      response = students.register(student_hash)
      expect(response).to be_kind_of(Manabu::Student)
      expect(students.roster(name: 'test')).to eq [response]

      students.delete(response)
    end

    it 'Obtiains the student roster with wrong name filter' do
      client = Manabu::Client.new('admin', 123456, 'localhost', 9000,
                                  force_secure_connection: false)
      students = Manabu::Students.new(client)
      student_hash = { name: 'test', surname: 'test' }

      response = students.register(student_hash)
      expect(response).to be_kind_of(Manabu::Student)
      expect(students.roster(name: 'nottest')).to eq []

      students.delete(response)
    end

    # it 'Obtains a roster filtered by age' do
    # end

    # it 'Obtains a roster filtered by school year' do
    # end

    # it 'Obtains a roster filtered by students enrolled in a specific class' do
    # end
  end
  context '.register' do
    it 'registers a student with a hash' do
      client = Manabu::Client.new('admin', 123456, 'localhost', 9000,
                                  force_secure_connection: false)
      students = Manabu::Students.new(client)
      student_hash = { name: 'test', surname: 'test' }

      response = students.register(student_hash)
      expect(response).to be_kind_of(Manabu::Student)
      expect(response.name).to eq('test')
      expect(response.id).to be_kind_of(Integer)
    end

    it 'registers a student with a Student object' do
      client = Manabu::Client.new('admin', 123456, 'localhost', 9000,
                                  force_secure_connection: false)
      students = Manabu::Students.new(client)
      student = Manabu::Student.new(client)
      student.name = 'test'
      student.surname = 'test'

      response = students.register(student)
      expect(response).to be_kind_of(Manabu::Student)
      expect(response.name).to eq('test')
      expect(response.id).to be_kind_of(Integer)
    end

    it 'raise Manabu::Connection::Error::UnprocessableEntity when param is missing' do
      expect {
        client = Manabu::Client.new('admin', 123456, 'localhost', 9000, force_secure_connection: false)
        students = Manabu::Students.new(client)

        student_hash = { name: 'test' }
        response = students.register(student_hash)
      }.to raise_error(Manabu::Connection::Error::UnprocessableEntity)
    end

  end
end
