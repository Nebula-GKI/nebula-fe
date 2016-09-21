class NebulaFe < Sinatra::Base
  get '/identity' do
    haml :identity
  end
end
