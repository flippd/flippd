require 'omniauth'
require 'json'

class Flippd < Sinatra::Application
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
  
  get '/auth/failure' do
    flash[:error] = "Could not sign you in due to: #{params[:message]}"
    redirect to('/')
  end
  
  get '/auth/destroy' do
    session[:user] = nil
    redirect to('/')
  end
end
