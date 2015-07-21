require 'omniauth'

class Flippd < Sinatra::Application
  use Rack::Session::Cookie, secret: 'change_me'
  use OmniAuth::Strategies::Developer
  
  before do
    @user = session[:user]
  end

  post '/auth/developer/callback' do
    auth_hash = env['omniauth.auth']
    name = auth_hash.info.name
    user_id = auth_hash.uid
    session[:user] = { name: name, id: user_id }
    redirect to('/')
  end
end
