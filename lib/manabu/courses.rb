require_relative 'client'

module Manabu
  class Courses

    def initialize(client)
      @client = client
      @courses = []
    end

    def all
      return @courses if @courses.any?

      # TODO format object
      response = @client.get('courses')
      @courses = response[:courses].map do |course|
        Manabu::Course.new(@client, course)
      end
    end

    def register(course)

      new_course = case course
      when Manabu::Course
        return register_course_by_object(course)
      when Hash
        return register_course_by_hash(course)
      end

      new_course.tap { |object| @courses.push object }

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
