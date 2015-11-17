require 'open-uri'
require 'json'

class Flippd < Sinatra::Application
  before do
    # Load in the configuration (at the URL in the project's .env file)
    @module = JSON.load(open(ENV['CONFIG_URL'] + "module.json"))
    @phases = @module['phases']

    # The configuration doesn't have to include identifiers, so we
    # add an identifier to each phase, video and quiz
    phase_id = 1
    video_quiz_id = 1
    @phases.each do |phase|
      phase["id"] = phase_id
      phase_id += 1

      phase['topics'].each do |topic|
        # The configuration doesn't have to include quizzes for every topic,
        # so we add an empty list of quizzes to the ones that don't
        if topic['quizzes'] == nil
          topic['quizzes'] = []
        end

        topic['videos'].each do |video|
          video["id"] = video_quiz_id
          video["type"] = "videos"
          video_quiz_id += 1
        end

        topic['quizzes'].each do |quiz|
          quiz['id'] = video_quiz_id
          quiz['type'] = "quizzes"
          video_quiz_id += 1
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

  get '/videos/:id' do
    @phases.each do |phase|
      phase['topics'].each do |topic|

        topic['videos'].each do |video|
          #Set the previous video
          if video["id"] == params['id'].to_i - 1
            @previous = video
          end
          #Set the current video
          if video["id"] == params['id'].to_i
            @phase = phase
            @video = video
          end
          #Set the next video
          if video["id"] == params['id'].to_i + 1
            @next = video
          end
        end

        topic['quizzes'].each do |quiz|
          #Set the previous quiz if there is one
          if quiz["id"] == params['id'].to_i - 1
            @previous = quiz
          end

          #Set the next quiz if there is one
          if quiz["id"] == params['id'].to_i + 1
            @next = quiz
          end
        end

      end
    end

    pass unless @video
    erb :video
  end
end
