class NebulaFe < Sinatra::Base
  get '/conversations' do
    @conversations = Nebula::Conversation.list($identity.conversations_path)
    haml :conversation
  end

  post '/conversation' do
    $current_conversation = Nebula::Conversation.new($identity.conversations_path + params[:conversation][:name], true)
    "Conversation created at: #{$current_conversation.root_path}"
  end
end
