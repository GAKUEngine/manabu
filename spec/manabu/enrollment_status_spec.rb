require 'spec_helper'

require 'manabu/student'
require 'manabu/students'
require 'manabu/enrollment_status'
describe Manabu::EnrollmentStatus do

  let(:client) {  Manabu::Client.new('admin', '123456', 'localhost', 9000,
                                  force_secure_connection: false) }


    it 'assign enrollment status to student' do
      # setup
      student = Manabu::Students.new(client)
        .register(name: 'test', surname: 'testov', enrollment_status_code: 'enrolled', birth_date: Date.today)

      expect(student.enrollment_status).to be_instance_of(Manabu::EnrollmentStatus)
      expect(student.enrollment_status.id).to_not be_nil
      expect(student.enrollment_status.code).to eq 'enrolled'
      # will add it when implement destroy student
    end
end
