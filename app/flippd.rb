require 'sinatra'
require 'rack-flash'

class Flippd < Sinatra::Application
  use Rack::Session::Cookie, secret: 'change_me'
  use Rack::Flash
end

require_relative 'routes/init'
