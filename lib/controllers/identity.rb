class NebulaFe < Sinatra::Base
  get '/identity' do
    @name = $identity.name
    haml :identity
  end

  post '/identity' do
    $identity.name = params[:identity][:name]
  end
end
