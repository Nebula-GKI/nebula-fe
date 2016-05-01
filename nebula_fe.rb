require 'pathname'
require 'sinatra'

require 'rubygems'
require 'action_view'
require 'active_support/core_ext'
require 'later_dude'
require 'sinatra/form_helpers'

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
  params.inspect
end
