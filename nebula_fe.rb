require 'pathname'
require 'sinatra'

require 'rubygems'
require 'action_view'
require 'active_support/core_ext'
require 'later_dude'
require 'sinatra/form_helpers'
require 'icalendar'
require 'nickel'

raise 'No conversation directory specified.' if ARGV.length < 1

conversation_root_dir = Pathname.new(ARGV.last)

get '/' do
  conversation_root_dir.entries.join("<br>\n")
end

get '/calendar' do
  current_time = Time.now

  LaterDude::Calendar.new(current_time.year, current_time.month).to_html
end

get '/event' do
  haml :event
end

post '/event' do
  raw_event  = params[:event]
  event      = Nickel.parse raw_event[:summary]

  # join the date and time back together since we can't seem to get that from Nickel directly
  start_time = Time.parse([event.occurrences.first.start_date, event.occurrences.first.start_time].join('T'))
  begin
    end_time   = Time.parse([event.occurrences.first.end_date, event.occurrences.first.end_time].join('T'))
  rescue ArgumentError
    # default to 1 hour if we are not given an end time
    end_time   = start_time + (1 * 60 * 60)
  end

  cal = Icalendar::Calendar.new
  cal.event do |e|
    e.dtstart     = start_time
    # :TODO: need to take a duration and calculate an offset time
    e.dtend       = end_time
    e.summary     = event.message
    e.description = raw_event[:description]
  end
  "<pre>#{cal.to_ical}</pre>"
end
