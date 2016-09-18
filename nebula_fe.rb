require 'sinatra'
require 'sinatra/json'

require 'rubygems'
require 'action_view'
require 'active_support/core_ext'
require 'later_dude'
require 'sinatra/form_helpers'
require 'sinatra/respond_with'
require 'multi_json'

# add our lib dir to the load path
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/lib')
require 'error'
require 'utility'
require 'conversation'
require 'message'
require 'event'
require 'task'

raise 'No conversation directory specified.' if ARGV.length < 1

respond_to :html, :json

conversation = Nebula::Conversation.new(ARGV.last)

get '/' do
  haml :main
end

get '/messages' do
  begin
    messages = Nebula::Message.list(conversation)
  rescue Errno::ENOENT
    messages = []
  end
  
  json messages
end

post '/message' do
  msg = MultiJson.load(request.body, symbolize_keys: true)
  STDERR.puts msg.inspect
  Nebula::Message.new(conversation, msg[:message]).save

  messages = Nebula::Message.list(conversation)

  status 201
  MultiJson.dump(messages)
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

get '/task' do
  haml :task
end

post '/task' do
  task = Nebula::Task.new(params[:task][:summary], params[:task][:description])
  task.save conversation
end
