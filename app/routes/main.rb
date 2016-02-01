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
    
    # Mark this video as unwatched - we will correct this if necessary
    @video_watched = false
    
    # Check if a user is logged in
  	if session.has_key?("user_id")
  		user_id = session['user_id']
  		
  		# If a user is logged in we will check if they have watched this video before
  		matches = VideosWatched.first(:user_id => user_id, :json_id => @video["id"])
        if matches != nil
        	@video_watched = true
        end
    end

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
  
  post '/videos/:id' do
  	video_id = params["id"]
  	badges_earnt = 0
  	
  	# Check that the user is logged in
  	if session.has_key?("user_id")
  		user_id = session['user_id']
  		user = User.get(session['user_id'])
  		
  		# Mark the video as watched in the database (if it isn't already)
  		matches = VideosWatched.first(:user_id => user_id, :json_id => video_id)
        if matches == nil
        	VideosWatched.create(:json_id => video_id, :date => Time.now, :user => user)
        end

  		# Check if video is a trigger for any badges
  		if BadgeUtils.is_any_trigger(video_id, @badges)
  			# Get all of the rewards for this video
  			rewards = BadgeUtils.get_triggered_badges(video_id, @badges)
  			# Loop through rewards, and if requirements are met then assign badge
  			rewards.each do |badge|
            	if BadgeUtils.check_requirements(user_id, badge)
                	BadgeUtils.award_badge(badge, user)
                	badges_earnt += 1
            	end
            end
        end
  	end
  	
  	# Return a count of how many badges we have awarded
  	badges_earnt.to_s
  	
  end
    
end
