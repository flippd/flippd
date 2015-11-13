require 'open-uri'
require 'json'

class Flippd < Sinatra::Application
  before do
    # Load in the configuration (at the URL in the project's .env file)
    @module = JSON.load(open(ENV['CONFIG_URL'] + "module.json"))
    @phases = @module['phases']

    # The configuration doesn't have to include identifiers, so we
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
    erb open(ENV['CONFIG_URL'] + "index.erb").read
  end

  get '/phases/:title' do
    @phase = nil
    @phases.each do |phase|
      @phase = phase if phase['title'].downcase.gsub(" ", "_") == params['title']
    end

    pass unless @phase
    erb :phase
  end

  before '/comment/new' do
    unless @user
      halt 401, "Error 401, Unauthorised"
    end
  end

  before '/comment/edit/:id' do
    unless @user
      halt 401, "Error 401, Unauthorised"
    end
    #@todo Allow the author of comment to edit
    unless @user.is_lecturer #or the auther
      halt 403, "Error 403, Forbidden"
    end
  end

  get '/videos/:id' do
    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['videos'].each do |video|
          if video["id"] == params['id'].to_i
            @phase = phase
            @video = video
            @comments = Comment.all(:videoId => @video["id"])
          end
        end
      end
    end

    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['videos'].each do |video|
          if video["id"] == params['id'].to_i + 1
            @next_video = video
          end
        end
      end
    end

    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['videos'].each do |video|
          if video["id"] == params['id'].to_i - 1
            @previous_video = video
          end
        end
      end
    end

    pass unless @video
    erb :video
  end
end
