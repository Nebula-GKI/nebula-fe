get '/messages' do
  begin
    messages = Nebula::Message.list($conversation)
  rescue Errno::ENOENT
    messages = []
  end

  json messages
end

post '/message' do
  msg = MultiJson.load(request.body, symbolize_keys: true)
  STDERR.puts msg.inspect
  Nebula::Message.new($conversation, msg[:message]).save

  messages = Nebula::Message.list($conversation)

  status 201
  MultiJson.dump(messages)
end
