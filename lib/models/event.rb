require 'nickel'
require 'icalendar'

module Nebula
  class Event
    class Error < Nebula::Error; end
    class InvalidDateString < Error; end

    DEFAULT_DURATION = 1.hour

    attr_reader :summary, :description, :start_dt, :message

    def initialize(summary, description = nil, start_dt = nil, duration = nil)
      @summary = summary
      @description = description
      @duration    = duration
      event        = Nickel.parse @summary
      @message     = event.message

      # join the date and time back together since we can't seem to get that from Nickel directly
      @start_dt = start_dt || Time.parse([event.occurrences.first.start_date, event.occurrences.first.start_time].join('T'))

      if @duration.nil?
        begin
          end_dt = [event.occurrences.first.end_date || event.occurrences.first.start_date, event.occurrences.first.end_time].join('T')
        rescue InvalidDateString => e
          # default to 1 hour if we are not given an end time
          STDERR.puts e
        end
      end
    end

    def duration
      @duration || DEFAULT_DURATION
    end

    def end_dt=(end_dt)
      begin
        end_time = Time.parse end_dt
        # :TODO: make sure that end time does not precede start time
        @duration = end_time - start_dt
      rescue ArgumentError
        raise InvalidDateString, end_dt
      end
    end

    def end_dt
      start_dt + duration
    end

    def to_ical (cal = Icalendar::Calendar.new)
      cal.event do |e|
        e.summary     = message
        e.description = description
        e.dtstart     = start_dt
        # :TODO: need to take a duration and calculate an offset time
        e.dtend       = end_dt
      end
      cal.to_ical
    end
  end
end
