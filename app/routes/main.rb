require 'open-uri'
require 'json'
require 'sinatra/base'
require './app/helpers/badge_utils'
require './app/helpers/phase_utils'

class Flippd < Sinatra::Application
  helpers BadgeUtils, PhaseUtils

  before do
    @session = session
    # Load in the configuration (at the URL in the project's .env file)
    @json_loc = ENV['CONFIG_URL'] + "module.json"
    @module = JSON.load(open(@json_loc))
    # From helpers/phase_utils
    @phases = load_phases(@module)
    # From helpers/badge_utils
    @badges = BadgeUtils.load_badges(@module)
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

  get '/videos/:pos' do
    pos = params["pos"].to_i
    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['videos'].each do |video|
          #Set the current video
          if video["pos"] == pos
            @phase = phase
            @video = video
          end
        end
      end
    end

    # Get the next and previous video/quiz to link to
    @previous = get_by_pos(@phases, pos-1)
    @next = get_by_pos(@phases, pos+1)

    pass unless @video
    erb :video
  end

  get '/quizzes/:pos' do
    pos = params["pos"].to_i
    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['quizzes'].each do |quiz|
          #Set the current quiz
          if quiz["pos"] == pos
            @phase = phase
            @quiz = quiz
          end
        end
      end
    end


    # Get the next and previous video/quiz to link to
    @previous = get_by_pos(@phases, pos-1)
    @next = get_by_pos(@phases, pos+1)

    pass unless @quiz
    erb :quiz
  end

  post '/quizzes/:pos' do
    pos = params["pos"].to_i
    @phase = @phases.first # FIXME
    @post  = params[:post]
    @quiz  = get_by_pos(@phases, pos)

    # Get the next and previous video/quiz to link to
    @previous = get_by_pos(@phases, pos-1)
    @next = get_by_pos(@phases, pos+1)

    @score = 0
    @post.each do |question_no, answer|
        if @quiz["questions"][question_no.to_i]["correct answer"] == answer
            @score += 1
        end
    end
    
    if session.has_key?("user_id")    
        user_id = session['user_id']
        user = User.get(session['user_id'])
        result = QuizResult.create(:json_id => @quiz["id"], :date => Time.now, :mark => @score, :user => user)
        rewards = BadgeUtils.get_triggered_badges(@quiz["id"], @badges)
        rewards.each do |badge|
            if BadgeUtils.check_requirements(user_id, badge)
                BadgeUtils.award_badge(badge, user)
            end
        end
    end

    erb :quiz_result
  end
end
