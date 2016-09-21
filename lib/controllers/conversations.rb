class NebulaFe < Sinatra::Base
  get '/conversations' do
    @conversations = Nebula::Conversation.list($identity.conversations_path)
    haml :conversation
  end
end
