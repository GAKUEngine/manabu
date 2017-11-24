require_relative 'transactor'
module Manabu
  class Students
    def initialize(auth)
      @auth = auth
    end

    def index
      transactor.get('v1/students')
    end

    def create(attributes = {})
      transactor.set('v1/students', student: attributes)
    end

    private

    def transactor
      @transactor = Transactor.new('localhost', 9000, false)
    end
  end
end
