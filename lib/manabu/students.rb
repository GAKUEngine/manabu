require_relative 'connection/transactor'
require_relative 'student/courses'

module Manabu
  class Students
    attr_accessor :client, :transactor

    def initialize(client)
      @client = client
      @transactor = client.transactor
    end

    def index
      transactor.get('v1/students')
    end

    def create(attributes = {})
      transactor.post('v1/students', student: attributes)
    end

    def update(id, attributes = {})
      transactor.patch("v1/students/#{id}", student: attributes)
    end

    def show(id)
      transactor.get("v1/students/#{id}")
    end

    def destroy(id)
      transactor.delete("v1/students/#{id}")
    end

    def courses(id)
      Manabu::Student::Courses.new(transactor, id)
    end


  end
end
