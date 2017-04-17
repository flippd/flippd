require 'dotenv'
Dotenv.load

require_relative 'db/init'

require 'sinatra'
require 'sinatra/multi_route'
require 'rack-flash'

class Flippd < Sinatra::Application
  register Sinatra::MultiRoute
  use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET']
  use Rack::Flash

  before do
    @version = "0.0.5"
  end

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end
end

require_relative 'routes/init'
