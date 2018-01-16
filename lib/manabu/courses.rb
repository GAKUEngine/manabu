require_relative 'client'

module Manabu
  class Courses
    def initialize(client)
      @client = client
    end

    def index
      # TODO format object
      @client.get('courses')
    end

    def register(course)
      case course
      when Manabu::Course
        return register_course_by_object(course)
      when Hash
        return register_course_by_hash(course)
      end
    end

    def register_course_by_object(course)
      res = @client.post('courses', course.to_hash)
      # TODO: handle errors
      course.fill(res)
    end

    def register_course_by_hash(course)
      res = @client.post('courses', course)
      # TODO: handle errors
      Manabu::Course.new(@client, res)
    end
  end
end
