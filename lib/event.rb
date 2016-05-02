require 'nickel'
require 'icalendar'

module Nebula
  class Event
    DEFAULT_DURATION = 1.hour

    attr_reader :summary, :description, :start_dt, :message

    def initialize(summary, description = nil, start_dt = nil, duration = nil)
      @summary = summary
      @description = description
      @duration    = duration
      event        = Nickel.parse @summary
      @message     = event.message

      # join the date and time back together since we can't seem to get that from Nickel directly
      @start_dt = Time.parse([event.occurrences.first.start_date, event.occurrences.first.start_time].join('T'))
      begin
        @end_dt   = Time.parse([event.occurrences.first.end_date || event.occurrences.first.start_date, event.occurrences.first.end_time].join('T'))
      rescue ArgumentError
        # default to 1 hour if we are not given an end time
        @end_dt   = @start_dt + duration
      end
    end

    def duration
      @duration || DEFAULT_DURATION
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
