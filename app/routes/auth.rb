require 'omniauth'

class Flippd < Sinatra::Application
  use OmniAuth::Strategies::Developer
  
  before do
    @user = session[:user]
  end

  post '/auth/developer/callback' do
    auth_hash = env['omniauth.auth']
    session[:user] = { name: auth_hash.info.name, id: auth_hash.uid}
    
    origin = env['omniauth.origin'] || '/'
    redirect to(origin)
  end
  
  get '/auth/failure' do
    flash[:error] = "Could not sign you in due to: #{params[:message]}"
    origin = env["HTTP_REFERER"] || '/'
    redirect to(origin)
  end
  
  get '/auth/destroy' do
    session[:user] = nil
    origin = env["HTTP_REFERER"] || '/'
    redirect to(origin)
  end
end
