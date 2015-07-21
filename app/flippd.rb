require 'sinatra/base'
require 'omniauth'
require 'json'

class Flippd < Sinatra::Base
  use Rack::Session::Cookie, secret: 'change_me'
  use OmniAuth::Strategies::Developer
  
  before do
    module_data_file = File.join(File.dirname(__FILE__), 'data', 'module.json')
    @module = JSON.parse(File.read(module_data_file))
  end

  get '/' do
    @user = session[:user]
    erb :index
  end
  
  post '/auth/developer/callback' do
    auth_hash = env['omniauth.auth']
    name = auth_hash.info.name
    user_id = auth_hash.uid
    session[:user] = { name: name, id: user_id }
    redirect to('/')
  end

  get '/video/:id' do
    videos_data_file = File.join(File.dirname(__FILE__), 'data', 'videos.json')
    videos_data = JSON.parse(File.read(videos_data_file))
    @video = videos_data[params['id']]

    pass unless @video
    erb :video
  end
end
