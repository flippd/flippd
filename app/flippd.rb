require 'sinatra/base'

class Flippd < Sinatra::Base
  get '/' do
    erb :index
  end
end
