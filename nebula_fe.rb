require 'pathname'
require 'sinatra'

require 'rubygems'
require 'action_view'
require 'active_support/core_ext'
require 'later_dude'
require 'sinatra/form_helpers'

# add our lib dir to the load path
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/lib')
require 'error'
require 'event'

raise 'No conversation directory specified.' if ARGV.length < 1

conversation_root_dir = Pathname.new(ARGV.last)

get '/' do
  haml :main
end

get '/calendar' do
  current_time = Time.now

  LaterDude::Calendar.new(current_time.year, current_time.month).to_html
end

get '/event' do
  haml :event
end

post '/event' do
  event = Nebula::Event.new(params[:event][:summary], params[:event][:description])
  "<pre>#{event.to_ical}</pre>"
end
