require_relative 'connection/transactor'
module Manabu
  class Courses
    attr_accessor :client, :transactor

    def initialize(client)
      @client = client
      @transactor = client.transactor
    end

    def index
      transactor.get('v1/courses')
    end

    def create(attributes = {})
      transactor.post('v1/courses', student: attributes)
    end

    def update(id, attributes = {})
      transactor.patch("v1/courses/#{id}", student: attributes)
    end

    def show(id)
      transactor.get("v1/courses/#{id}")
    end

    def destroy(id)
      transactor.delete("v1/courses/#{id}")
    end

  end
end
