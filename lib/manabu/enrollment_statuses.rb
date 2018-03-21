require_relative 'enrollment_status'
module Manabu
  class EnrollmentStatuses
    attr_accessor :client

    def initialize(client)
      @client = client
      @enrollment_statuses = []
    end

    def all
      return @enrollment_statuses unless @enrollment_statuses.empty?

      response = @client.get("/enrollment_statuses")

      @enrollment_statuses =  response.map do |enrollment_status|
        Manabu::EnrollmentStatus.new(@client, enrollment_status)
      end
    end
  end
end
