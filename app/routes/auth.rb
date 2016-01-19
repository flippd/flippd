require 'omniauth'

class Flippd < Sinatra::Application
  if ENV['AUTH'] == "GOOGLE"
    require 'omniauth-google-oauth2'
    use OmniAuth::Strategies::GoogleOauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
    get('/auth/new') { redirect to('/auth/google_oauth2') }
  else
    use OmniAuth::Strategies::Developer
    get('/auth/new') { redirect to('/auth/developer') }
  end

  before do
    @user = nil
    @user = User.get(session[:user_id]) if session.key?(:user_id)
  end

  route :get, :post, '/auth/:provider/callback' do
    auth_hash = env['omniauth.auth']
    user = User.first_or_create({ email: auth_hash.info.email }, { name: auth_hash.info.name} )
    session[:user_id] = user.id

    origin = env['omniauth.origin'] || '/'
    redirect to(origin)
  end

  get '/auth/failure' do
    flash[:error] = "Could not sign you in due to: #{params[:message]}"
    origin = env["HTTP_REFERER"] || '/'
    redirect to(origin)
  end

  get '/auth/destroy' do
    session.delete(:user_id)
    origin = env["HTTP_REFERER"] || '/'
    redirect to(origin)
  end
end
