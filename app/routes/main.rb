require 'json'

class Flippd < Sinatra::Application
  before do
    module_data_file = File.join(File.dirname(__FILE__), '..', 'data', 'module.json')
    @module = JSON.parse(File.read(module_data_file))
  end

  get '/' do
    erb :index
  end

  get '/video/:id' do
    videos_data_file = File.join(File.dirname(__FILE__), '..', 'data', 'videos.json')
    videos_data = JSON.parse(File.read(videos_data_file))
    @video = videos_data[params['id']]

    pass unless @video
    erb :video
  end
end
