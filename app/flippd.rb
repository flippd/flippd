require 'sinatra/base'

class Flippd < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/video' do
    erb :video
  end
end
