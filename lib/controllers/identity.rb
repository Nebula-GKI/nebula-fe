class NebulaFe < Sinatra::Base
  get '/identity' do
    @name = $identity.name
    @conversations_path = $identity.conversations_path
    haml :identity
  end

  post '/identity' do
    $identity.name = params[:identity][:name]
  end
end
