require 'json'

class Flippd < Sinatra::Application
  before do
    module_data_file = File.join(File.dirname(__FILE__), '..', 'data', 'module.json')
    @module = JSON.parse(File.read(module_data_file))
    @phases = @module['phases']

    # add an identifier to each phase and video
    phase_id = 1
    video_id = 1
    @phases.each do |phase|
      phase["id"] = phase_id
      phase_id += 1

      phase['topics'].each do |topic|
        topic['videos'].each do |video|
          video["id"] = video_id
          video_id += 1
        end
      end
    end
  end

  get '/' do
    erb :index
  end

  get '/phases/:title' do
    @phase = nil
    @phases.each do |phase|
      @phase = phase if phase['title'].downcase.gsub(" ", "_") == params['title']
    end

    pass unless @phase
    erb :phase
  end

  get '/videos/:id' do
    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['videos'].each do |video|
          if video["id"] == params['id'].to_i
            @phase = phase
            @video = video
          end
        end
      end
    end

    pass unless @video
    erb :video
  end
end
