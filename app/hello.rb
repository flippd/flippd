require 'sinatra/base'

class Hello < Sinatra::Base
  get '/' do
    erb :index
  end
end
