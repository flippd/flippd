require 'sinatra'
require 'rack-flash'

class Flippd < Sinatra::Application
  use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET']
  use Rack::Flash
end

require_relative 'routes/init'
