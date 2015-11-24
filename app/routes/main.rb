require 'open-uri'
require 'json'

class Flippd < Sinatra::Application
  def get_by_id(phases, id)
    phases.each do |phase|
      phase['topics'].each do |topic|

        topic['videos'].each do |video|
          if video["id"] == id
            return video
          end
        end

        # If a video with the matching ID was not found,
        # the ID must correspond to a quiz
        topic['quizzes'].each do |quiz|
          if quiz["id"] == id
            return quiz
          end
        end

      end
    end

    return nil
  end

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
          #Set the current video
          if video["id"] == params['id'].to_i
            @phase = phase
            @video = video
          end
        end
      end
    end

    # Get the next and previous video/quiz to link to
    @previous = get_by_id(@phases, params["id"].to_i - 1)
    @next = get_by_id(@phases, params["id"].to_i + 1)

    pass unless @video
    erb :video
  end

  get '/quizzes/:id' do
    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['quizzes'].each do |quiz|
          #Set the current quiz
          if quiz["id"] == params['id'].to_i
            @phase = phase
            @quiz = quiz
          end
        end
      end
    end


    # Get the next and previous video/quiz to link to
    @previous = get_by_id(@phases, params["id"].to_i - 1)
    @next = get_by_id(@phases, params["id"].to_i + 1)

    pass unless @quiz
    erb :quiz
  end

  post '/quiz_result/:id' do
    @phase = @phases.first # FIXME
    @post  = params[:post]
    @quiz  = get_by_id(@phases, params["id"].to_i)

    # Get the next and previous video/quiz to link to
    @previous = get_by_id(@phases, params["id"].to_i - 1)
    @next = get_by_id(@phases, params["id"].to_i + 1)

    @score = 0
    @post.each do |question_no, answer|
        if @quiz["questions"][question_no.to_i]["correct answer"] == answer
            @score += 1
        end
    end

    erb :quiz_result
  end
end
