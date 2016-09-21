class NebulaFe < Sinatra::Base
  get '/conversations' do
    haml :conversation
  end
end
