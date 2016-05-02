require 'pathname'
require 'sinatra'

require 'rubygems'
require 'action_view'
require 'active_support/core_ext'
require 'later_dude'
require 'sinatra/form_helpers'
require 'icalendar'

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
  event = params[:event]

  cal = Icalendar::Calendar.new
  cal.event do |e|
    e.dtstart     = Icalendar::Values::Date.new(event[:start])
    # :TODO: need to take a duration and calculate an offset time
    e.dtend       = Icalendar::Values::Date.new(event[:duration])
    e.summary     = event[:summary]
    e.description = event[:description]
  end
  "<pre>#{cal.to_ical}</pre>"
end
